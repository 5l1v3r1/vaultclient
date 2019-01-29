#include "vcStrings.h"
#include "vCore/vStringFormat.h"
#include "udPlatform/udFile.h"
#include "udPlatform/udJSON.h"

#include <string>
#include <unordered_map>

namespace vcString
{
  static std::unordered_map<std::string, const char*> gStringTable;

  // pValue needs to be already duplicated before calling this function
  void Set(const char *pKey, const char *pValue)
  {
    const char *pExistingValue = gStringTable[pKey];

    if (pExistingValue != nullptr)
      udFree(pExistingValue);

    gStringTable[pKey] = pValue;
  }

  const char* Get(const char *pKey)
  {
    const char *pValue = gStringTable[pKey];

    if (pValue == nullptr)
    {
      // Caches the mising string-
      gStringTable[pKey] = vStringFormat("{MISSING/{0}}", pKey);
      return gStringTable[pKey];
    }
    else
    {
      return pValue;
    }
  }

  vdkError LoadTable(vcState *pProgramState, const char *pFilename)
  {
    char *pPos = nullptr;
    if (pFilename == nullptr || udFile_Load(pFilename, (void **)&pPos) != udR_Success)
      pPos = udStrdup(""); // So this can be free'd later

    udJSON strings;

    if (strings.Parse(pPos) != udR_Success)
      strings.SetObject();

    udFree(pPos);

    size_t count = strings.MemberCount();

    for (size_t i = 0; i < count; ++i)
    {
      const char *pKey = strings.GetMemberName(i);
      const char *pValue = strings.GetMember(i)->AsString();

      if (pValue != nullptr)
        Set(pKey, udStrdup(pValue));
    }

    // Concatenations
    Set("LoginWaiting", vStringFormat("{0}##LoginWaiting", Get("Login")));
    Set("RememberServer", vStringFormat("{0}##rememberServerURL", Get("Remember")));
    Set("RememberUser", vStringFormat("{0}##rememberUsername", Get("Remember")));
    Set("SettingsAppearance", vStringFormat("{0}##Settings", Get("Appearance")));

    Set("InputControlsID", vStringFormat("{0}##Settings", Get("InputControls")));
    Set("ViewportID", vStringFormat("{0}##Settings", Get("Viewport")));
    Set("DegreesFormat", vStringFormat("%.0f {0}", Get("Degrees")));
    Set("ElevationFormat", vStringFormat("{0}##Settings", Get("Elevation")));
    Set("VisualizationFormat", vStringFormat("{0}##Settings", Get("Visualization")));
    Set("RestoreColorsID", vStringFormat("{0}##RestoreClassificationColors", Get("MenuRestoreDefaults")));

    const char *latLongAlt[] = { Get("Lat"), Get("Long"), Get("Alt") };
    Set("LatLongAlt", vStringFormat("{0}: %.7f, {1}: %.7f, {2}: %.2fm", latLongAlt, 3));
    Set("InactiveSlash", vStringFormat("{0} /", Get("Inactive")));
    Set("AppearanceRestore", vStringFormat("{0}##AppearanceRestore", Get("MenuRestoreDefaults")));
    Set("InputRestore", vStringFormat("{0}##InputRestore", Get("MenuRestoreDefaults")));
    Set("ViewportRestore", vStringFormat("{0}##ViewportRestore", Get("MenuRestoreDefaults")));
    Set("MapsRestore", vStringFormat("{0}##MapsRestore", Get("MenuRestoreDefaults")));
    Set("VisualizationRestore", vStringFormat("{0}##VisualizationRestore", Get("MenuRestoreDefaults")));

    const char *format5[] = { Get("UpdateAvailableLong"), pProgramState->packageInfo.Get("package.versionstring").AsString(), Get("InYourVaultServer") };
    if (format5[1] == nullptr)
      format5[1] = "";

    Set("PackageUpdate", vStringFormat("{0} {1} {2}", format5, 3));

    return vE_Success;
  }

  void FreeTable()
  {
    for (std::pair<std::string, const char*> kvp : gStringTable)
      udFree(kvp.second);

    gStringTable.clear();
  }
}