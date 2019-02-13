#ifndef vcMenuButtons_h__
#define vcMenuButtons_h__

enum vcMenuBarButtonIcon
{
  vcMBBI_Translate = 0,
  vcMBBI_Rotate = 1,
  vcMBBI_Scale = 2,
  vcMBBI_ShowCameraSettings = 3,
  vcMBBI_LockAltitude = 4,
  vcMBBI_ShowGeospatialInfo = 5,
  vcMBBI_MeasureLine = 6,
  vcMBBI_MeasureArea = 7,
  vcMBBI_MeasureVolume = 8,
  vcMBBI_UseLocalSpace = 9,

  vcMBBI_AddPointCloud = 10,
  vcMBBI_AddPointOfInterest = 11,
  vcMBBI_AddAreaOfInterest = 12,
  vcMBBI_AddLines = 13,
  vcMBBI_AddFolder = 14,
  vcMBBI_Remove = 15,
  vcMBBI_AddOther = 16,

  // Reserved 17-19

  vcMBBI_FilterSphere = 20,
  vcMBBI_FilterBox = 21,
  vcMBBI_FilterCylinder = 22,
  vcMBBI_FilterCrossSection = 23,

  //Reserved = 24 - 29

  vcMBBI_ShowColour = 30,
  vcMBBI_ShowIntensity = 31,
  vcMBBI_ShowClassification = 32,

  vcMBBI_FullScreen = 33

  //Reserved = 34 +
};

enum vcMenuBarButtonGap
{
  vcMBBG_FirstItem, // This is the first item
  vcMBBG_SameGroup, // Small Gap from previous item
  vcMBBG_NewGroup, // Large Gap from previous item
};

struct vcTexture;

bool vcMenuBarButton(vcTexture *pUITexture, const char *pButtonName, const char *pKeyCode, const vcMenuBarButtonIcon buttonIndex, vcMenuBarButtonGap gap, bool selected = false);

#endif //vcMenuButtons_h__
