#include "vcSceneItem.h"

#include "vcState.h"
#include "vcRender.h"

vdkProjectNode* vcSceneItem_CreateNodeInProject(vdkProject *pProject, const char *pType, const char *pName)
{
  vdkProjectNode *pNode = nullptr;

  vdkProjectNode_Create(pProject, &pNode, pType, pName, nullptr, nullptr);

  UDASSERT(pNode != nullptr, "Remove Path to this- memory alloc failed.");

  return pNode;
}

vcSceneItem::vcSceneItem(vdkProjectNode *pNode) :
  m_loadStatus(0),
  m_visible(true),
  m_selected(false),
  m_expanded(false),
  m_editName(false),
  m_moved(false),
  m_pPreferredProjection(nullptr),
  m_pCurrentProjection(nullptr)
{
  m_metadata.SetVoid();
  m_pNode = pNode;
}

vcSceneItem::vcSceneItem(vdkProject *pProject, const char *pType, const char *pName) :
  vcSceneItem(vcSceneItem_CreateNodeInProject(pProject, pType, pName))
{
  // Do nothing
}

vcSceneItem::~vcSceneItem()
{
  m_metadata.Destroy();
  udFree(m_pPreferredProjection);
  udFree(m_pCurrentProjection);
}

void vcSceneItem::ChangeProjection(const udGeoZone &newZone)
{
  if (this->m_pCurrentProjection != nullptr && newZone.srid != m_pCurrentProjection->srid)
    memcpy(m_pCurrentProjection, &newZone, sizeof(newZone));
}

void vcSceneItem::SetCameraPosition(vcState *pProgramState)
{
  pProgramState->pCamera->position = GetWorldSpacePivot();
}

udDouble3 vcSceneItem::GetWorldSpacePivot()
{
  return (this->GetWorldSpaceMatrix() * udDouble4::create(this->GetLocalSpacePivot(), 1.0)).toVector3();
}

udDouble3 vcSceneItem::GetLocalSpacePivot()
{
  return udDouble3::zero(); //TODO: Consider somehow defaulting to Camera Position instead
}

udDouble4x4 vcSceneItem::GetWorldSpaceMatrix()
{
  return udDouble4x4::identity();
}