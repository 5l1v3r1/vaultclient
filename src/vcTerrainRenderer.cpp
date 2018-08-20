#include "vcTerrainRenderer.h"
#include "vcTerrain.h"

#include "gl/vcGLState.h"
#include "gl/vcMeshUtils.h"
#include "gl/vcRenderShaders.h"
#include "gl/vcShader.h"
#include "gl/vcMesh.h"

#include "vcQuadTree.h"
#include "vcSettings.h"
#include "udPlatform/udPlatformUtil.h"
#include "udPlatform/udChunkedArray.h"
#include "udPlatform/udThread.h"
#include "udPlatform/udFile.h"
#include "vcGIS.h"

#include "stb_image.h"

// temporary hard codeded
static const int VertResolution = 2;
static const int IndexResolution = VertResolution - 1;

struct vcTile
{
  vcTexture *pTexture;
  udDouble4x4 world[4]; // each tile corner has different world transform
};

struct vcCachedTexture
{
  udInt3 id; // each tile has a unique slippy {x,y,z}
  vcTexture *pTexture;

  int32_t width, height;
  void *pData;

  double priority; // lower is better. (distanceSqr to camera)
  udDouble3 tilePosition;
  bool isVisible; // if associated tile is part of the current scene (latest quad tree data)
};

struct vcTerrainRenderer
{
  vcTile *pTiles;
  int tileCount;

  udDouble4x4 latestViewProjectionMatrix;

  vcSettings *pSettings;
  vcMesh *pMesh;

  // cache textures
  struct vcTerrainCache
  {
    volatile bool keepLoading;
    udThread *pThreads[4];
    udSemaphore *pSemaphore;
    udMutex *pMutex;
    udChunkedArray<vcCachedTexture*> textureLoadList;
    udChunkedArray<vcCachedTexture> textures;
  } cache;

  struct
  {
    vcShader *pProgram;
    vcShaderConstantBuffer *pConstantBuffer;
    vcShaderSampler *uniform_texture;

    struct
    {
      udFloat4x4 worldViewProjections[4];
      udFloat4 colour; // Colour Multiply
    } everyObject;
  } presentShader;
};

void vcTerrainRenderer_LoadThread(void *pThreadData)
{
  vcTerrainRenderer *pRenderer = (vcTerrainRenderer*)pThreadData;
  vcTerrainRenderer::vcTerrainCache *pCache = &pRenderer->cache;

  while (pCache->keepLoading)
  {
    int loadStatus = udWaitSemaphore(pCache->pSemaphore, 1000);

    if (loadStatus != 0 && pCache->textureLoadList.length == 0)
      continue;

    while (pCache->textureLoadList.length > 0 && pCache->keepLoading)
    {
      udLockMutex(pCache->pMutex);

      // Choose the next tile to load based on 'priority':
      // 1. visibility (in frustum)
      // 2. distance based
      vcCachedTexture *pNextTexture = nullptr;
      size_t best = (size_t)-1;
      bool hasFrustumPriority = false;
      for (size_t i = 0; i < pCache->textureLoadList.length; ++i)
      {
        if (!pCache->textureLoadList[i]->isVisible)
          continue;

        // TODO: frustum plane approach for correct AABB frustum detection
        udDouble4 tileCenter = pRenderer->latestViewProjectionMatrix * udDouble4::create(pCache->textureLoadList[i]->tilePosition.x, pCache->textureLoadList[i]->tilePosition.y, 0.0, 1.0);
        bool hasHigherPriority = pNextTexture ? (pCache->textureLoadList[i]->priority <= pNextTexture->priority) : true;
        bool isInFrustum = tileCenter.x >= -tileCenter.w && tileCenter.x <= tileCenter.w &&
          tileCenter.y >= -tileCenter.w && tileCenter.y <= tileCenter.w &&
          tileCenter.z >= -tileCenter.w && tileCenter.z <= tileCenter.w;

        // as soon as we detect a tile inside the frustum, only consider other tiles
        // also in that frustum.
        bool isBetter = isInFrustum ? (!hasFrustumPriority || hasHigherPriority) : (!hasFrustumPriority && hasHigherPriority);
        if (isBetter)
        {
          best = i;
          pNextTexture = pCache->textureLoadList[i];
        }
        hasFrustumPriority |= isInFrustum;
      }

      if (best == (size_t)-1)
      {
        udReleaseMutex(pCache->pMutex);
        break;
      }

      pCache->textureLoadList.RemoveSwapLast(best);

      char buff[256];
      udSprintf(buff, sizeof(buff), "%s/%d/%d/%d.png", pRenderer->pSettings->maptiles.tileServerAddress, pNextTexture->id.z, pNextTexture->id.x, pNextTexture->id.y);
      udReleaseMutex(pCache->pMutex);

      void *pFileData;
      int64_t fileLen;
      int width, height, channelCount;

      if (udFile_Load(buff, &pFileData, &fileLen) != udR_Success)
        continue;

      uint8_t *pData = stbi_load_from_memory((stbi_uc*)pFileData, (int)fileLen, (int*)&width, (int*)&height, (int*)&channelCount, 4);

      if (pData == nullptr)
      {
        // TODO: if this occurs, put back in the queue?
        goto epilogue;
      }

      pNextTexture->pData = udMemDup(pData, sizeof(uint32_t)*width*height, 0, udAF_None);

      pNextTexture->width = width;
      pNextTexture->height = height;

epilogue:
      udFree(pFileData);
      stbi_image_free(pData);
    }
  }
}

void vcTerrainRenderer_Init(vcTerrainRenderer **ppTerrainRenderer, vcSettings *pSettings)
{
  vcTerrainRenderer *pTerrainRenderer = udAllocType(vcTerrainRenderer, 1, udAF_Zero);

  pTerrainRenderer->pSettings = pSettings;

  pTerrainRenderer->cache.pSemaphore = udCreateSemaphore();
  pTerrainRenderer->cache.pMutex = udCreateMutex();
  pTerrainRenderer->cache.keepLoading = true;
  pTerrainRenderer->cache.textures.Init(128);
  pTerrainRenderer->cache.textureLoadList.Init(16);

  for (size_t i = 0; i < UDARRAYSIZE(vcTerrainRenderer::vcTerrainCache::pThreads); ++i)
    udThread_Create(&pTerrainRenderer->cache.pThreads[i], (udThreadStart*)vcTerrainRenderer_LoadThread, pTerrainRenderer);

  vcShader_CreateFromText(&pTerrainRenderer->presentShader.pProgram, g_terrainTileVertexShader, g_terrainTileFragmentShader, vcSimpleVertexLayout, UDARRAYSIZE(vcSimpleVertexLayout));
  vcShader_GetConstantBuffer(&pTerrainRenderer->presentShader.pConstantBuffer, pTerrainRenderer->presentShader.pProgram, "u_EveryObject", sizeof(pTerrainRenderer->presentShader.everyObject));
  vcShader_GetSamplerIndex(&pTerrainRenderer->presentShader.uniform_texture, pTerrainRenderer->presentShader.pProgram, "u_texture");

  // build our vertex/index list
  vcSimpleVertex verts[VertResolution * VertResolution];
  int indices[IndexResolution* IndexResolution * 6];
  for (int y = 0; y < IndexResolution; ++y)
  {
    for (int x = 0; x < IndexResolution; ++x)
    {
      int index = y * IndexResolution + x;
      int vertIndex = y * VertResolution + x;
      indices[index * 6 + 0] = vertIndex + VertResolution;
      indices[index * 6 + 1] = vertIndex + 1;
      indices[index * 6 + 2] = vertIndex;

      indices[index * 6 + 3] = vertIndex + VertResolution;
      indices[index * 6 + 4] = vertIndex + VertResolution + 1;
      indices[index * 6 + 5] = vertIndex + 1;
    }
  }

  float normalizeVertexPositionScale = float(VertResolution) / (VertResolution - 1); // ensure verts are [0, 1]
  for (int y = 0; y < VertResolution; ++y)
  {
    for (int x = 0; x < VertResolution; ++x)
    {
      int index = y * VertResolution + x;
      verts[index].position.x = float(index ? (1 << (index-1)) : 0);
      verts[index].position.y = 0.0f;
      verts[index].position.z = 0.0f;

      verts[index].uv.x = ((float)(x) / VertResolution) * normalizeVertexPositionScale;
      verts[index].uv.y = ((float)(y) / VertResolution) * normalizeVertexPositionScale;
    }
  }

  vcMesh_Create(&pTerrainRenderer->pMesh, vcSimpleVertexLayout, 2, verts, VertResolution * VertResolution, indices, IndexResolution * IndexResolution * 6);
  (*ppTerrainRenderer) = pTerrainRenderer;
}

void vcTerrainRenderer_Destroy(vcTerrainRenderer **ppTerrainRenderer)
{
  if (ppTerrainRenderer == nullptr || *ppTerrainRenderer == nullptr)
    return;

  vcTerrainRenderer *pTerrainRenderer = (*ppTerrainRenderer);

  pTerrainRenderer->cache.keepLoading = false;
  udIncrementSemaphore(pTerrainRenderer->cache.pSemaphore);

  for (size_t i = 0; i < UDARRAYSIZE(vcTerrainRenderer::vcTerrainCache::pThreads); ++i)
  {
    udThread_Join(pTerrainRenderer->cache.pThreads[i]);
    udThread_Destroy(&pTerrainRenderer->cache.pThreads[i]);
  }

  udDestroyMutex(&pTerrainRenderer->cache.pMutex);
  udDestroySemaphore(&pTerrainRenderer->cache.pSemaphore);

  for (size_t i = 0; i < pTerrainRenderer->cache.textures.length; ++i)
  {
    udFree(pTerrainRenderer->cache.textures[i].pData);
    vcTexture_Destroy(&pTerrainRenderer->cache.textures[i].pTexture);
  }

  pTerrainRenderer->cache.textures.Deinit();
  pTerrainRenderer->cache.textureLoadList.Deinit();

  //TODO: Cleanup uniforms
  vcShader_DestroyShader(&pTerrainRenderer->presentShader.pProgram);

  vcMesh_Destroy(&pTerrainRenderer->pMesh);

  udFree(*ppTerrainRenderer);
}

vcCachedTexture* FindTexture(udChunkedArray<vcCachedTexture> &textures, const udInt3 &slippyCoord)
{
  for (size_t i = 0; i < textures.length; ++i)
  {
    vcCachedTexture *pTexture = &textures[i];
    if (pTexture->id.x == slippyCoord.x && pTexture->id.y == slippyCoord.y && pTexture->id.z == slippyCoord.z)
    {
      return pTexture;
    }
  }

  return nullptr;
}

vcTexture* AssignTileTexture(vcTerrainRenderer *pTerrainRenderer, const udInt3 &slippyCoord, udDouble3 &tileCenterPosition, double distToCameraSqr)
{
  vcTexture *pResultTexture = nullptr;
  vcCachedTexture *pCachedTexture = FindTexture(pTerrainRenderer->cache.textures, slippyCoord);

  if (pCachedTexture == nullptr)
  {
    // Texture needs to be loaded, cache it
    pTerrainRenderer->cache.textures.PushBack(&pCachedTexture);

    pCachedTexture->pData = nullptr;
    pCachedTexture->id = slippyCoord;
    pCachedTexture->pTexture = nullptr;

    pCachedTexture->priority = distToCameraSqr;
    pCachedTexture->tilePosition = tileCenterPosition;
    pTerrainRenderer->cache.textureLoadList.PushBack(pCachedTexture);
    udIncrementSemaphore(pTerrainRenderer->cache.pSemaphore);
  }
  else if (pCachedTexture->pData != nullptr) // texture is already in cache but might not be loaded yet
  {
    vcTexture_Create(&pCachedTexture->pTexture, pCachedTexture->width, pCachedTexture->height, pCachedTexture->pData, vcTextureFormat_RGBA8, vcTFM_Linear, false, vcTWM_Clamp);
    udFree(pCachedTexture->pData);
  }

  if (pCachedTexture != nullptr && pCachedTexture->pTexture != nullptr)
    pResultTexture = pCachedTexture->pTexture;

  pCachedTexture->isVisible = true;

  return pResultTexture;
}

void vcTerrainRenderer_BuildTiles(vcTerrainRenderer *pTerrainRenderer, int16_t srid, const udInt3 &slippyCoords, const udDouble3 &cameraLocalPosition, const vcQuadTreeNode *pNodeList, int nodeCount, int visibleNodeCount)
{
  // TODO: for now just throw everything out every frame
  udFree(pTerrainRenderer->pTiles);
  pTerrainRenderer->pTiles = udAllocType(vcTile, visibleNodeCount, udAF_Zero);
  pTerrainRenderer->tileCount = visibleNodeCount;

  // invalidate all streaming textures
  udLockMutex(pTerrainRenderer->cache.pMutex);
  for (size_t i = 0; i < pTerrainRenderer->cache.textureLoadList.length; ++i)
    pTerrainRenderer->cache.textureLoadList[i]->isVisible = false;

  int visibleTileIndex = 0;

  for (int i = 0; i < nodeCount; ++i)
  {
    const vcQuadTreeNode *pNode = &pNodeList[i];
    if (!vcQuadTree_IsLeafNode(pNode) || !pNode->isVisible)
      continue;

    udInt3 slippyTileCoord = udInt3::create(pNode->slippyPosition.x, pNode->slippyPosition.y, pNode->level + slippyCoords.z);
    udDouble3 localCorners[4]; // nw, ne, sw, se
    for (int t = 0; t < 4; ++t)
    {
      vcGIS_SlippyToLocal(srid, &localCorners[t], udInt2::create(slippyTileCoord.x + (t % 2), slippyTileCoord.y + (t / 2)), slippyTileCoord.z);
      pTerrainRenderer->pTiles[visibleTileIndex].world[t] = udDouble4x4::translation(localCorners[t].x, localCorners[t].y, 0.0);
    }
    udDouble3 tileCenterPosition = (localCorners[1] + localCorners[2]) * 0.5;

    double distToCameraSqr = udMagSq2(cameraLocalPosition.toVector2() - tileCenterPosition.toVector2());
    vcTexture *pTexture = AssignTileTexture(pTerrainRenderer, slippyTileCoord, tileCenterPosition, distToCameraSqr);

    pTerrainRenderer->pTiles[visibleTileIndex].pTexture = nullptr;
    if (pTexture != nullptr)
      pTerrainRenderer->pTiles[visibleTileIndex].pTexture = pTexture;

    ++visibleTileIndex;
  }

  udReleaseMutex(pTerrainRenderer->cache.pMutex);
}

void vcTerrainRenderer_Render(vcTerrainRenderer *pTerrainRenderer, const udDouble4x4 &viewProj)
{
  if (pTerrainRenderer->tileCount == 0)
    return;

  pTerrainRenderer->latestViewProjectionMatrix = viewProj;

  // for debugging
#if 0
  int visibleCount = 0;
  for (size_t i = 0; i < pTerrainRenderer->cache.textureLoadList.length; ++i)
    visibleCount += pTerrainRenderer->cache.textureLoadList[i]->isVisible ? 1 : 0;

  printf("visibleTiles=%d: totalLoad=%zu\n", visibleCount, pTerrainRenderer->cache.textureLoadList.length);
#endif

  vcGLState_SetFaceMode(vcGLSFM_Solid, vcGLSCM_None);

  vcShader_Bind(pTerrainRenderer->presentShader.pProgram);

  vcGLState_SetBlendMode(vcGLSBM_Interpolative);

  if (pTerrainRenderer->pSettings->maptiles.blendMode == vcMTBM_Overlay)
    vcGLState_SetDepthMode(vcGLSDM_Always, false);

  pTerrainRenderer->presentShader.everyObject.colour = udFloat4::create(1.f, 1.f, 1.f, pTerrainRenderer->pSettings->maptiles.transparency);

  udDouble4x4 mapHeightTranslation = udDouble4x4::translation(0, 0, pTerrainRenderer->pSettings->maptiles.mapHeight);
  udDouble4x4 viewProjWithMapTranslation = viewProj * mapHeightTranslation;

  for (int i = 0; i < pTerrainRenderer->tileCount; ++i)
  {
    vcTile *pTile = &pTerrainRenderer->pTiles[i];
    if (pTile->pTexture == nullptr)
      continue;

    for (int t = 0; t < 4; ++t)
    {
      udFloat4x4 tileWV = udFloat4x4::create(viewProjWithMapTranslation * pTile->world[t]);
      pTerrainRenderer->presentShader.everyObject.worldViewProjections[t] = tileWV;
    }

#if UD_DEBUG
    srand(i);
    pTerrainRenderer->presentShader.everyObject.colour = udFloat4::create(float(rand()) / RAND_MAX, float(rand()) / RAND_MAX, float(rand()) / RAND_MAX, pTerrainRenderer->pSettings->maptiles.transparency);
#endif

    vcShader_BindConstantBuffer(pTerrainRenderer->presentShader.pProgram, pTerrainRenderer->presentShader.pConstantBuffer, &pTerrainRenderer->presentShader.everyObject, sizeof(vcTerrainRenderer::presentShader.everyObject));
    vcShader_BindTexture(pTerrainRenderer->presentShader.pProgram, pTerrainRenderer->pTiles[i].pTexture, 0);
    vcMesh_RenderTriangles(pTerrainRenderer->pMesh, IndexResolution * IndexResolution * 2); // 2 because 2tris per quad
  }

  if (pTerrainRenderer->pSettings->maptiles.blendMode == vcMTBM_Overlay)
    vcGLState_SetDepthMode(vcGLSDM_LessOrEqual, true);

  vcGLState_SetBlendMode(vcGLSBM_None);

  vcShader_Bind(nullptr);
}


void vcTerrainRenderer_ClearCache(vcTerrainRenderer *pTerrainRenderer)
{
  udLockMutex(pTerrainRenderer->cache.pMutex);
  pTerrainRenderer->cache.textureLoadList.Clear();
  udReleaseMutex(pTerrainRenderer->cache.pMutex);

  for (size_t i = 0; i < pTerrainRenderer->cache.textures.length; ++i)
  {
    udFree(pTerrainRenderer->cache.textures[i].pData);
    vcTexture_Destroy(&pTerrainRenderer->cache.textures[i].pTexture);
  }

  udFree(pTerrainRenderer->pTiles);
  pTerrainRenderer->tileCount = 0;
}
