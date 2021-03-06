#include "vcVerticalMeasureTool.h"
#include <stdio.h>

#include "vcState.h"
#include "vcRender.h"
#include "vcStrings.h"

#include "vcFenceRenderer.h"
#include "vcInternalModels.h"

#include "udMath.h"
#include "udFile.h"
#include "udStringUtil.h"
#include "vcWebFile.h"
#include "vcUnitConversion.h"

#include "imgui.h"
#include "imgui_ex/vcImGuiSimpleWidgets.h"

vcVerticalMeasureTool::vcVerticalMeasureTool(vcProject *pProject, vdkProjectNode *pNode, vcState *pProgramState) :
  vcSceneItem(pProject, pNode, pProgramState)
  , m_done(false)
  , m_pickStart(true)
  , m_pickEnd(true)
  , m_markDelete(false)
  , m_pLineInstance(nullptr)
{
  ClearPoints();

  vcLineRenderer_CreateLine(&m_pLineInstance);

  for (auto &label: m_labelList)
  {
    label.pText = nullptr;
    label.textColourRGBA = vcIGSW_BGRAToRGBAUInt32(vcIGSW_ImGuiToBGRA(pProgramState->settings.tools.label.textColour));
    label.backColourRGBA = vcIGSW_BGRAToRGBAUInt32(vcIGSW_ImGuiToBGRA(pProgramState->settings.tools.label.backgroundColour));
  }
  

  OnNodeUpdate(pProgramState);
  m_loadStatus = vcSLS_Loaded;
}
vcVerticalMeasureTool::~vcVerticalMeasureTool()
{
}

void vcVerticalMeasureTool::Preview(const udDouble3 &position)
{
  m_points[2] = position;
}

void vcVerticalMeasureTool::EndMeasure(vcState *pProgramState, const udDouble3 &position)
{
  m_points[2] = position;
  m_done = true;
  pProgramState->activeTool = vcActiveTool::vcActiveTool_Select;
  vdkProjectNode_SetMetadataBool(m_pNode, "measureEnd", m_done);
}

void vcVerticalMeasureTool::OnNodeUpdate(vcState *pProgramState)
{
  vdkProjectNode_GetMetadataBool(m_pNode, "pickStart", &m_pickStart, true);
  vdkProjectNode_GetMetadataBool(m_pNode, "pickEnd", &m_pickEnd, true);
  vdkProjectNode_GetMetadataBool(m_pNode, "measureEnd", &m_done, false);

  ChangeProjection(pProgramState->geozone);
  UpdateSetting(pProgramState);
}


void vcVerticalMeasureTool::AddToScene(vcState *pProgramState, vcRenderData *pRenderData)
{
  if (pProgramState->activeTool != vcActiveTool::vcActiveTool_MeasureHeight && !m_done && HasLine())
  {
    m_markDelete = true;
    return;
  }

  if (!m_visible)
    return;

  if (m_selected && (m_pickStart || !m_done))
  {
    vcRenderPolyInstance *pInstance = pRenderData->polyModels.PushBack();
    udDouble3 linearDistance = (pProgramState->camera.position - m_points[0]);
    pInstance->pModel = gInternalModels[vcInternalModelType_Sphere];
    pInstance->worldMat = udDouble4x4::translation(m_points[0]) * udDouble4x4::scaleUniform(udMag3(linearDistance) / 100.0); //This makes it ~1/100th of the screen size
    pInstance->pSceneItem = this;
    pInstance->pDiffuseOverride = pProgramState->pWhiteTexture;
    pInstance->sceneItemInternalId = 1;
    pInstance->renderFlags = vcRenderPolyInstance::RenderFlags_Transparent;
    pInstance->tint = udFloat4::create(1.0f, 1.0f, 1.0f, 0.65f);
    pInstance->selectable = false;
  }
  

  if (HasLine())
  {
    UpdateIntersectionPosition(pProgramState);

    if (m_selected && (m_pickEnd || !m_done))
    {
      vcRenderPolyInstance *pInstance = pRenderData->polyModels.PushBack();
      udDouble3 linearDistance = (pProgramState->camera.position - m_points[2]);
      pInstance->pModel = gInternalModels[vcInternalModelType_Sphere];
      pInstance->worldMat = udDouble4x4::translation(m_points[2]) * udDouble4x4::scaleUniform(udMag3(linearDistance) / 100.0); //This makes it ~1/100th of the screen size
      pInstance->pSceneItem = this;
      pInstance->pDiffuseOverride = pProgramState->pWhiteTexture;
      pInstance->sceneItemInternalId = 2;
      pInstance->renderFlags = vcRenderPolyInstance::RenderFlags_Transparent;
      pInstance->tint = udFloat4::create(1.0f, 1.0f, 1.0f, 0.65f);
      pInstance->selectable = false;
    }

    for (auto &label : m_labelList)
      udFree(label.pText);

    m_labelList[0].worldPosition = (m_points[0] + m_points[1]) / 2;
    m_labelList[1].worldPosition = (m_points[1] + m_points[2]) / 2;

    char labelBuf[128] = {};
    udSprintf(labelBuf, "%s\n%s: %.3f\n%s: %.3f", m_pNode->pName, vcString::Get("sceneStraightDistance"), udMag3(m_points[0] - m_points[2]), vcString::Get("sceneHorizontalDistance"), udMag2(m_points[0] - m_points[2]));
    m_labelList[0].pText = udStrdup(labelBuf);

    char labelBufVertical[128] = {};
    udSprintf(labelBufVertical, "%s: %.3f", vcString::Get("sceneVerticalDistance"), udAbs(m_points[0].z - m_points[2].z));
    m_labelList[1].pText = udStrdup(labelBufVertical);

    for (auto &label : m_labelList)
      pRenderData->labels.PushBack(&label);

    vcProject_UpdateNodeGeometryFromCartesian(m_pProject, m_pNode, pProgramState->geozone, vdkPGT_LineString, m_points, 3);
    vcLineRenderer_UpdatePoints(m_pLineInstance, m_points, 3, vcIGSW_BGRAToImGui(m_lineColour), m_lineWidth, false);
    pRenderData->lines.PushBack(m_pLineInstance);
  }

}

void vcVerticalMeasureTool::ApplyDelta(vcState *pProgramState, const udDouble4x4 &delta)
{
  if (m_pickStart)
    m_points[0] = (delta * udDouble4x4::translation(m_points[0])).axis.t.toVector3();

  if (m_pickEnd)
    m_points[2] = (delta * udDouble4x4::translation(m_points[2])).axis.t.toVector3();

  vcProject_UpdateNodeGeometryFromCartesian(m_pProject, m_pNode, pProgramState->geozone, vdkPGT_LineString, m_points, 3);
}

void vcVerticalMeasureTool::HandleSceneExplorerUI(vcState *pProgramState, size_t *pItemID)
{
  if (ImGui::Checkbox(udTempStr("%s##Select1%zu", vcString::Get("scenePOIMHeightPickStart"), *pItemID), &m_pickStart))
    vdkProjectNode_SetMetadataBool(m_pNode, "pickStart", m_pickStart);

  ImGui::InputScalarN(udTempStr("%s##Start%zu", vcString::Get("scenePOIPointPosition"), *pItemID), ImGuiDataType_Double, &m_points[0].x, 3);

  if (HasLine())
  {
    if (ImGui::Checkbox(udTempStr("%s##Select2%zu", vcString::Get("scenePOIMHeightPickEnd"), *pItemID), &m_pickEnd))
      vdkProjectNode_SetMetadataBool(m_pNode, "pickEnd", m_pickEnd);

    ImGui::InputScalarN(udTempStr("%s##End%zu", vcString::Get("scenePOIPointPosition"), *pItemID), ImGuiDataType_Double, &m_points[2].x, 3);
    if (ImGui::IsItemDeactivatedAfterEdit())
      vcProject_UpdateNodeGeometryFromCartesian(m_pProject, m_pNode, pProgramState->geozone, vdkPGT_LineString, m_points, 3);

    if (ImGui::SliderFloat(udTempStr("%s##VerticalLineWidth%zu", vcString::Get("scenePOILineWidth"), *pItemID), &m_lineWidth, 3.f, 15.f, "%.2f", 3.f))
      vdkProjectNode_SetMetadataDouble(m_pNode, "lineWidth", m_lineWidth);

    if (vcIGSW_ColorPickerU32(udTempStr("%s##VerticalLineColour%zu", vcString::Get("scenePOILineColour1"), *pItemID), &m_lineColour, ImGuiColorEditFlags_None))
      vdkProjectNode_SetMetadataUint(m_pNode, "lineColour", m_lineColour);

    if (vcIGSW_ColorPickerU32(udTempStr("%s##VerticalLabelColour%zu", vcString::Get("scenePOILabelColour"), *pItemID), &m_textColourBGRA, ImGuiColorEditFlags_None))
    {
      for (auto &label : m_labelList)
        label.textColourRGBA = vcIGSW_BGRAToRGBAUInt32(m_textColourBGRA);
      vdkProjectNode_SetMetadataUint(m_pNode, "nameColour", m_textColourBGRA);
    }

    if (vcIGSW_ColorPickerU32(udTempStr("%s##VerticalLabelBackgroundColour%zu", vcString::Get("scenePOILabelBackgroundColour"), *pItemID), &m_textBackgroundBGRA, ImGuiColorEditFlags_None))
    {
      for (auto &label : m_labelList)
        label.backColourRGBA = vcIGSW_BGRAToRGBAUInt32(m_textBackgroundBGRA);
      vdkProjectNode_SetMetadataUint(m_pNode, "backColour", m_textBackgroundBGRA);
    }

    if (vcIGSW_InputText(vcString::Get("scenePOILabelDescription"), m_description, sizeof(m_description), ImGuiInputTextFlags_EnterReturnsTrue))
      vdkProjectNode_SetMetadataString(m_pNode, "description", m_description);

    ImGui::Text("%s: %.3f", vcString::Get("sceneStraightDistance"), udMag3(m_points[0] - m_points[2]));
    ImGui::Text("%s: %.3f", vcString::Get("sceneHorizontalDistance"), udMag2(m_points[0] - m_points[2]));
    ImGui::Text("%s: %.3f", vcString::Get("sceneVerticalDistance"), udAbs(m_points[0].z - m_points[2].z));

  }
}

void vcVerticalMeasureTool::HandleSceneEmbeddedUI(vcState *pProgramState)
{
  char buffer[128];

  ImGui::Text("%s", vcString::Get("sceneStraightDistance"));
  ImGui::PushFont(pProgramState->pBigFont);
  ImGui::Indent();
  vcUnitConversion_ConvertDistanceToString(buffer, udLengthOf(buffer), udMag3(m_points[0] - m_points[2]), vcDistance_Metres);
  ImGui::Text("%s", buffer);
  ImGui::Unindent();
  ImGui::PopFont();

  ImGui::Text("%s", vcString::Get("sceneHorizontalDistance"));
  ImGui::PushFont(pProgramState->pBigFont);
  ImGui::Indent();
  vcUnitConversion_ConvertDistanceToString(buffer, udLengthOf(buffer), udMag2(m_points[0] - m_points[2]), vcDistance_Metres);
  ImGui::Text("%s", buffer);
  ImGui::Unindent();
  ImGui::PopFont();

  ImGui::Text("%s", vcString::Get("sceneVerticalDistance"));
  ImGui::PushFont(pProgramState->pBigFont);
  ImGui::Indent();
  vcUnitConversion_ConvertDistanceToString(buffer, udLengthOf(buffer), udAbs(m_points[0].z - m_points[2].z), vcDistance_Metres);
  ImGui::Text("%s", buffer);
  ImGui::Unindent();
  ImGui::PopFont();
}

void vcVerticalMeasureTool::Cleanup(vcState *pProgramState)
{
  ClearPoints();

  if (m_pLineInstance)
  {
    vcLineRenderer_DestroyLine(&m_pLineInstance);
    m_pLineInstance = nullptr;
  }

  for (auto &label : m_labelList)
    udFree(label.pText);

  pProgramState->activeTool = vcActiveTool::vcActiveTool_Select;
}

void vcVerticalMeasureTool::ChangeProjection(const udGeoZone &newZone)
{
  udDouble3 *pPoints = nullptr;
  int number = 0;
  vcProject_FetchNodeGeometryAsCartesian(m_pProject, m_pNode, newZone, &pPoints, &number);
  if(number > 0)
    m_points[0] = pPoints[0];

  udFree(pPoints);
  pPoints = nullptr;
}

udDouble3 vcVerticalMeasureTool::GetLocalSpacePivot()
{
  if (!HasLine() || !m_done || (m_done && m_pickStart))
    return m_points[0];
  else
    return m_points[2];
}

void vcVerticalMeasureTool::UpdateIntersectionPosition(vcState *pProgramState)
{
  if (!HasLine())
    return;

  udDouble3 localStartPoint = udGeoZone_TransformPoint(m_points[0], pProgramState->geozone, pProgramState->activeProject.baseZone);
  udDouble3 localEndPoint = udGeoZone_TransformPoint(m_points[2], pProgramState->geozone, pProgramState->activeProject.baseZone);
  udDouble3 direction = localEndPoint - localStartPoint;
  udDouble3 middle = udDouble3::zero();
  if (direction.z > 0)
    middle = udDouble3::create(localStartPoint.x, localStartPoint.y, localEndPoint.z);
  else
    middle = udDouble3::create(localEndPoint.x, localEndPoint.y, localStartPoint.z);

  m_points[1] = udGeoZone_TransformPoint(middle, pProgramState->activeProject.baseZone, pProgramState->geozone);

}

bool vcVerticalMeasureTool::HasLine()
{
  return m_points[2] != udDouble3::zero();
}

void vcVerticalMeasureTool::ClearPoints()
{
  for (size_t i = 0; i < udLengthOf(m_points); i++)
    m_points[i] = udDouble3::zero();
}

void vcVerticalMeasureTool::UpdateSetting(vcState *pProgramState)
{
  int32_t size = vcLFS_Medium;
  vdkProjectNode_GetMetadataInt(m_pNode, "textSize", &size, pProgramState->settings.tools.label.textSize);
  vdkProjectNode_GetMetadataUint(m_pNode, "nameColour", &m_textColourBGRA, vcIGSW_ImGuiToBGRA(pProgramState->settings.tools.label.textColour));
  vdkProjectNode_GetMetadataUint(m_pNode, "backColour", &m_textBackgroundBGRA, vcIGSW_ImGuiToBGRA(pProgramState->settings.tools.label.backgroundColour));

  uint32_t textColourRGBA = vcIGSW_BGRAToRGBAUInt32(m_textColourBGRA);
  uint32_t backColourRGBA = vcIGSW_BGRAToRGBAUInt32(m_textBackgroundBGRA);
  for (auto &label : m_labelList)
  {
    label.textColourRGBA = textColourRGBA;
    label.backColourRGBA = backColourRGBA;
  }

  vdkProjectNode_GetMetadataUint(m_pNode, "lineColour", &m_lineColour, vcIGSW_ImGuiToBGRA(pProgramState->settings.tools.line.colour));

  double width = pProgramState->settings.tools.line.width;
  vdkProjectNode_GetMetadataDouble(m_pNode, "lineWidth", &width, pProgramState->settings.tools.line.width);
  m_lineWidth = (float)width;

  const char *pTemp;
  vdkProjectNode_GetMetadataString(m_pNode, "description", &pTemp, "");
  udStrcpy(m_description, pTemp);
}

void vcVerticalMeasureTool::HandleToolUI(vcState * pProgramState)
{
  if (HasLine())
  {
    ImGui::PushFont(pProgramState->pBigFont);
    ImGui::Text("%s: %.3f", vcString::Get("sceneStraightDistance"), udMag3(m_points[0] - m_points[2]));
    ImGui::PopFont();
  }  
}
