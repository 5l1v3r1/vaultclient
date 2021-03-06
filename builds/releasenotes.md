Euclideon Vault Client Version History

Known Issues In Current Release
  - Please see https://dev.azure.com/euclideon/vaultclient/_workitems/recentlyupdated for up to date information
  - Pointcloud Export
    - Round trip for exporting pointclouds doesn't always give the same model
    - Export to UDS doesn't copy all metadata
  - Map mode is unavailable
  - Displacement compare
    - Calculation doesn't always work correctly
    - Sits at 0% for a long time while during initial processing
  - Some LAZ files fail to convert
  - Some SLPK files fail to render correctly and SLPK pointcloud is unsupported

Version 0.6.1 (Minor Bug Fix Release)
  - Added helper system for translations
    - Updated Chinese translations
    - Recieved Japanese translation from Kimoto Group <support-geoverse@kimoto.co.jp>
  - Fixed lots of issues with the Emscripten build
  - Improved sun positioning
  - Fixes for entering and leaving full screen mode
  - Camera input fixes, particularly when looking directly up or down
  - Repositioned the icons so they are better centred on the buttons
  - Fixed issue where minor network drops were causing models to disappear
  - Fixed issues with UI elements opening the wrong pop up windows
  - Non-geolocated UDS files will be dropped at the mouse position
  - Project base SRID can now be specified per project
  - Fixes for lines being transparent on some devices
  - Fixed a number of issues for non-geolocated models
  - Optimisations to map tile loading

Version 0.6.0
  - Major overhaul to the entire UI
    - Moved the frequently used tools to the UI
    - Added key bindings for many of the tools
    - Increased the scene size to use as much of the window as possible
    - Removed menu bar and moved its contents to other parts of the UI
    - Shrunk the compass and using a more traditional compass style
  - Better limits on movement speed
  - Added support for Earth Centred, Earth Fixed (Globe Rendering)
  - Improvements to custom tile servers to allow API keys and other (supported) texture formats
  - Optimisations to polygon loading (particularly with lots of textures)
  - Voxel shaders can now be set per model in the scene rather than using the global scene settings
  - Added setting to snap the mouse to a nearby voxel (helps to avoid 'missing' the pointcloud and zooming off into space)
  - [Technical] Shaders are now stored as assets rather than embedded
  - Fixes to SLPK loader (thanks to everyone that submitted broken SLPK files!)
  - Tidied up the settings so that settings are more logically grouped together
  - Added a more standard 'line' mode (screen space lines)
  - Added prompts for confirmation of destructive actions
  - Improved support for offline sessions
  - Added information when no licenses are available (relogging can help)
  - Added convert status to the scene UI
  - Added attribution text using metadata from the UDS "Copyright" field
  - Added "Help" button to open the website for the latest support documentation
  - Added Euclideon hosted Elevation data to the terrain
  - [Experimental] Atmospheric Scattering (available as a skybox)

Version 0.5.0
  - Reenabled FBX conversion on Windows and macOS
  - Viewsheds now work on polygon models
  - Added (basic) point displacement calculations
  - Removed view distance slider (now using different technique that doesn't require the setting)
  - Lots of improvements to models attached to lines (face culling, improved material support)
  - Polygon textures are now loaded asynchronously (doesn't stall the application while they load)
  - Added (basic) session resume support so that licenses can continue to be used
  - Added settings to rebind hotkeys
  - Consolidated all settings to a single modal
  - Optimized SLPK loading
  - Added anti-aliasing
  - Added saturation controls
  - Fixed several issues in relation to resetting failed conversions
  - Added (basic) High-DPI monitor support
  - Added Copy/Paste context menu to most text input fields
  - Fixed "Projects" menu not being available when client hadn't finished requesting the server list
  - Added support for native file dialogs (Windows only currently)
  - Added user profile modal
  - Removed docking of scene, scene explorer and convert to simplify the UI
  - Fixed issues with folders in folders in scene explorer
  - Added high-resolution screenshot export support
  - Added ability to export a model (optionally with a filter) to UDS or LAS

Version 0.4.0
  - Conversion Improvements
    - Fixed issue with resetting some conversion types
    - Increased support for additional types of FBX files
    - Added drop down to set all spaces in a conversion rather than doing it individually
    - Convert CMD takes a global offset now (`-globaloffset X Y Z`)
    - Added Earth Centred, Earth Fixed support to conversion
    - Fixed some issues with estimation of resolution for conversion
    - Added support for additional SRID codes from customers and the community
  - Improvements to SLPK
    - Loading prioritizes objects closer to the camera
    - Fixed some crashes that occurred when loading lots of SLPK files at the same time from fast disks
    - Added ability to reset I3S models positions from the context menu
  - Various rendering improvements
    - The scene is scaled properly to avoid aliasing affects
    - Improved performance when moving the mouse over the scene window with lots of polygon objects
    - Added basic lighting to Polygon models (including existing Live Feed and SLPK files)
  - Added small selectable spheres when some types of scene nodes are selected to assist with editing
  - Window Position and Size is remembered between sessions (including if it is maximised)
  - Added support for oriented media nodes (photo's that can face a certain direction)
  - Added ability to select a sub-item of a scene node
  - Added an error message when the server URL is blank
  - Added ability to pan and zoom from sky box (under review- will be tweaked. Feedback on this is appreciated)
  - Added ability to natively render OBJ and VSM files
  - Added feature to attach polygon models to move along lines and area perimeters
  - Added panoramic viewsheds
  - Added basic geometric filters for UDS files
  - Added support for relative paths when loading JSON projects
  - Added new settings
    - Now possible to display a colour gradient in conjunction with contours
    - Option to always show the Euclideon logo on the screen
    - License check out as part of login
    - Invert X and Y for controller inputs
  - Fixed lots of minor bugs:
    - Fixed an issue where random transform were taking place when using the gizmo's in specific circumstances
    - Fixed edge cases where horizontal lines were forming corkscrews
    - Input events are no longer lost when focus comes back
    - Hotkeys no longer activate when the user is typing in a text field
    - Increased the number of labels required to be on screen before graphical glitches occur (now millions rather than around a thousand)
    - Going into and out of presentation mode many times quickly no longer stops the mouse working in the scene tab
    - Media node images load correctly more often
    - Sped up excessive login and license checkout times that were occurring when in very slow network environments with machines that have very fast per core CPUs

Version 0.3.1
  - Improvements
    - Added support for FBX (macOS and Windows)
    - Previously used map tile servers names aren't leaked in the cache system
    - Added support for selecting directories correctly in the temporary and output directory modals
    - Reordered the convert jobs panel so the information that is more relevant is first
    - Images in the scene can be set to reload over time
  - Other Fixes and Changes
    - Renaming of scene items works again
    - Improved Chinese localization (submitted from Hongzhi Liu)
    - Slider no longer has "sticky" points in the settings menu
    - Fixed issues with convert text boxes not allowing input
    - SLPKs in long folder paths now function correctly
    - Map tiles are correctly blended into the scene again
    - Images in the scene correctly save and load their settings from the project and exif data again
    - Updated code signing certificate on Windows because the old one expired (different signature now)
    - Improved conversion support for OBJ, PTX and PTS from broken files submitted by the community (thanks everyone!)
    - Restored initial licence request information and made it more clear when a license is being requested

Version 0.3.0
  - Improvements
    - Projects can be exported as GeoJSON
      - Lots of preparation work for collaborative projects
    - I3S/SLPK format support (rendering and convert)
    - Selected items are highlighted in the scene and it's possible to select items from the scene
    - Updated convert interface
    - Added experimental GPU renderer (this does not currently support all features)
  - Other Fixes and Changes
    - Fixed an issue where login message for bad username/password was wrong
    - Massive internal tidying up to better support Web and Mobile devices
    - Tweaked colour table for light colour theme to make it more legible
    - Removed rounded borders to be more consistent throughout the application
    - Significant optimisations to how tiles are loaded
    - Language list is loaded from a file to make it easier to add custom languages
    - Startup is faster with a quick 'loading' screen added
      - Additionally possible to change languages from the System menu now
    - Lots of fixes to how GIS was handled (changing zones should be a lot less jarring now)
    - Improved handling of drag and drop so that files dropped onto the convert window are correctly handled by convert
      - Items dropped outside of convert are not handled by convert now
    - Split out Media and saved Camera locations to specific nodes for this purpose (POI is now about marking up or measuring an area)
    - Added Delete to the scene explorer context menu
    - Fixed issues related to conversion from inside zip files
    - Fixed some files that were submitted to us as failing- Thanks to everyone that sent us files!
    - Updated to Experimental Docking branch for ImGui (native docking support instead of extension)
      - Docked tabs can be closed correctly now
    - Fixed issues with conversions completing too quickly making the UI look like the conversion stopped midway
    - Login in slightly faster
    - Auto detect proxy no longer crashes on Windows
    - Minor improvements to line and area POI display and added the construction fence
    - Live feeds are loaded in chunks to preserve performance

Version 0.2.3
  - Improvements
    - Added Gamepad/Xbox Controller functionality for camera movement (EVC-203)
    - Removed the troublesome CSV importer for POI's/Labels (EVC-494)
    - Added camera smoothing (EVC-471)
    - Added ability to fly through the POI line (EVC-477 & EVC-512)
    - Removed confusion about near and far planes, there is now only 1 slider "View Distance" (EVC-493)
    - Map Tiles are now cached locally so revisiting the same area is faster (EVC-485)
    - Added 'Move Forward' mouse option for Geoverse MDM fans (EVC-504)
    - Added image POI's thumbnails to the scene (EVC-510)
    - Added option to generate and show a low quality preview during conversion
    - Gizmo is now off by default and can be toggled on and off (EVC-332)
    - Added support and translation details to the login page
  - Fixed Crashes
    - DirectX no longer crashes on systems that don't support OpenGL3.2
    - Tiles no longer crash when server doesn't respond correctly (EVC-487)
    - No longer crashes after resetting to default in some configurations (EVC-501)
  - Other fixes
    - Gizmo's now work correctly in map mode (EVC-491, EVC-475, EVC-482)
    - Consistent Logout after 15minutes on macOS resolved (EVC-449)
    - POIs from dropped images are now positioned correctly if the window doesn't have focus (EVC-465)
    - Watermarks are calculated from the center of the model (EVC-470)
    - Moving to point resets camera roll to zero correctly (EVC-471)
    - Points in POIs are able to be removed or inserted (EVA-472)
    - Camera no longer snaps after the window gains focus (EVC-476)
    - Scale gizmo now behaves as expected (EVC-480)
    - Fixed some camera input issues that resulted in the camera getting confused and rolling around (EVC-488 & EVC-483)
    - Removed erroneous {0}/{1] during convert (EVC-492)
    - Reverse up/down controls in map mode to be more consistent with what most people expect (EVC-495)
    - Added a delay for the tool tips (EVC-416)
    - Fixed issues with OBJ's with empty string texture names not being processed correctly

Version 0.2.2
  - Fixed an issue with the camera misbehaving when looking straight down in perspective mode
  - Added camera smoothing (EVC-471)
  - The file dialog modal now starts loading after pressing enter/return on the input name field (EVC-414)
  - Made auto-logout when the server cannot be pinged much less aggressive (EVA-449)
  - Modified translation strings (Translation Guide was updated to suit) (EVC-469)
  - Settings are now saved pretty, making them easier to modify by hand if required (EVC-472)
  - Updated default server addressed
    - Vault server defaults to the multi-region server instead of the trial server
    - Map Tiles defaults to the new tile server (http://slippy.vault.euclideon.com)
  - Using updated backgrounds for the login screen (VASS-18 & VASS-19)

Version 0.2.1
  - Scene & Scene Explorer changes
    - Map tiles now fade in (EVC-361)
    - The projected space and camera position are reset back to 0 when clearing the scene
    - UDS files with unknown SRID's will attempt to use the WKT embedded in the UDS to create a projection
    - Removed the padding string from displaying in the metadata
    - Fixed issue with manual entry of large values into camera position causing a crash (EVC-385, EVC-386)
    - Added "Add Other" button to Scene Explorer (will be used for less common scene item types)
    - Fixed a number of issues relating to the gizmos.
      - Multiple objects can be selected and manipulated at the same time
      - Scale is now calcualated correctly and doesn't reapply every frame
    - Added Map Mode (orthographic rendering) (EVC-227)
    - Added a right-click context menu to add POIs, set the map height and Move To (EVC-392, EVC-399)
    - Fixed Depth being miscalculated in some situations (EVC-421)
    - Fixed issue where pressing delete while editing a scene item would delete it (EVC-383)
    - Changed colour of drag line when adding scene items to folders (EVC-397)
    - The resolution a model was converted at is displayed in its properties (EVC-443)
    - Fixed a slowdown that occurred when viewing diagnostic information (EVC-446)
  - Points of Interest changes
    - Can now add points to the (singular) selected POI from the world context menu (EVC-256)
    - POIs are created on top of the camera by default (EVC-346)
    - Colours of the line are changeable
    - Fixed an issue with fence rendered UV calculation sometimes being incorrect
    - Area and Length can be displayed in the label (EVC-257)
    - Added Selector for if the polygon is closed or not (EVC-351)
    - Can now select a single point via the POI properties to manipulate individually
    - The label is now centred from all the points instead of just on the first point
    - The label font size is attempted to be maintained from UDP projects (Vault POI's only have 3 settings though)
    - Added slider to Appearance Settings to control the max visible distance of POIs (EVC-374)
    - Added the ability to import specific label formats from CSV (EVC-239)
    - Added support for loading label hyperlinks from UDP
    - Added support for some image file extensions to open in image viewer modal
    - Dropping an image onto the scene will create a POI at that point with an image attached (EVC-458)
    - Updated the artwork for the lines (VASS-15)
  - Lots of improvements to conversion
    - Readded ability to reset convert tasks
    - Added the option to offset the global starting position of a converted and imported model
    - Added the option to perform a Quick Partial Convert to avoid long wait times when testing convert settings
    - Improved point estimates by updating them more frequently during the conversion process
    - Added the ability to remove watermarks on the convert tab (EVC-387)
    - Fixed issue with temp directory incorrectly changing when modifying the output name (EVC-358, EVC-382)
    - Fixed issue with convert jobs not being cleared or cancelled on logout (EVC-444)
    - "Add To Scene" takes the user to the Scene window (EVC-378)
    - Added OBJ file format support (EVC-440)
    - Fixed issues with specific watermarks (EVC-437)
    - Fixed a memory leak related to metadata not being cleaned up correctly
    - Fixed a number of issues related to models submitted by customers (thanks for your assistance)
      - LAS files in WGS84 occasionally hit an edge case and wouldn't be located correctly (EVC-83)
      - Lots of file types miscalculated the number of points (EVC-427, EVC-441, EVC-442)
  - Miscellaneous Changes
    - Added preliminary support for Vault Live Feeds
    - Added a fancy new login screen
    - Fixed issue with scene tab accepting input while modals were open
    - Added a built-in Image Viewer
    - Added ability to change to appropriate tab when files are dropped
    - Fixed issue with error appearing for macOS users after logging in (EVC-448)
    - Fixed issue with new version detection on macOS (EVC-433)
    - Fixed issue with load file modal textbox retaining previously loaded file (EVC-412)
    - Capped the inputs of a lot of the settings to avoid crashes or unexpected behaviour (EVC-452)
    - Fixed issue with Caps lock being report wrong on Windows if you start the program with caps lock on (EVC-453)
    - Fixed lots of issues related to changing projection spaces (EVC-428, EVC-429)
      - also lots of crashes for the same (EVC-316, EVC-407, EVC-409, EVC-411, EVC-430, EVC-447, EVC-450, EVC-364, EVC-388)
    - Lots of the UI was updated to support localization
    - Fixed a few situations where text would leave the window and no scroll or word wrap occurred (EVC-141)
    - Added proper documentation on the command line convertor (EVC-362)
    - Fixed a memory leak related to license renewal
    - Fixed a number of reported issues with the user guide (EVC-366, EVC-367)
    - Fixed a number of issues relating to loading with URLs (EVC-365, EVC-376, EVC-377)
    - Fixed various typos (EVC-379, EVC-380, EVC-381, EVC-419, EVC-422)

Version 0.2.0
  - Added user guide, we will continue to improve this in the next release to cover all existing features
  - Added a menu bar for frequently changed settings (EVC-298)
    - Added keyboard shortcuts for those settings as well (EVC-238)
  - Fixed some size issues with some of the modals (EVC-285) and added support for pressing ESC to close them
  - Vault Convert CMD is packaged with Vault Client for the Windows and Ubuntu builds (EVC-304)
  - Fixed an issue with the wrapping of the camera (EVC-299)
  - Full screen is no longer tracked in the settings to prevent issues with multiple monitor configurations (EVC-9)
  - Significant improvements to how the build in assets are handled internally (EVC-286)
  - Basic Geoverse MDM project (UDP file) importing (EVC-287)
  - Proper wizard for changing the tile server and added support for JPG tiles (EVC-290 & EVC-206) also optimized the tile system (EVC-251)
  - Fixed an issue with the mouse position being incorrect on Linux (EVC-27)
  - Better clearing of internal state during logout to prevent information leaking between sessions (EVC-283, EVC-284 & EVC-292)
  - Swapped the names of the DirectX and OpenGL builds on Windows to better clarify that the DirectX version is the better supported version (EVC-281)
  - The compass is no longer affected by FOV as this was causing confusion for some users (EVC-62)
  - Added Gizmos to move items around in the scene (EVC-288, EVC-297 & EVC-294)
  - The load indicator has been slowed down and now only ticks a few times a second
  - Removed unnessecary columns from the scene explorer in favour of the more standard tree view system
    - Added folders for filtering options
    - Items can be dragged in the tree to reorder
  - Fixed an issue with jumping between projections causing a crash in some situations (EVC-315)
  - Fixed an issue with the release notes not being renderered correctly (EVC-314)
  - You can now rename the user defined classifications (EVC-308)
  - Removed the "Classic" theme option as there was confusion as to why it didn't look like Classic Windows (EVC-306)
  - Added button which can be held down to show your password immediately after you've typed it (EVC-278)
  - Added a presentation mode (EVC-212)
  - Improved background loading of resources destined for the GPU (EVC-293)
  - Updated VDK also provides a number of minor improvements
    - Fixed an issue that caused a user to rejoin the queue every time it requested a license while already in queue
    - Better support for concatenated PTS files (UD-19)
    - Fixed issue with classification being averaged instead of picking one of the points for LOD calculations (UD-2)

Version 0.1.2
  - Seperated the project codes for Vault Server / Vault Development kit (EVA) from the Euclideon Vault Client codes (EVC)
  - Changed the rotation of the camera in the UI to display in degrees (EVC-70)
  - Added proxy support and added option to ignore peer and host certificate verification (EVA-391)
  - Added outlines to the first model in the scene when the diagnostic information is enabled (EVC-243)
  - Fixed an issue where the temp or output directories not being available caused convert to hand indefinately (EVC-115)
  - Fixed some bundling issues that prevented macOS 0.1.1 being released (EVC-153, EVC-88)
  - Fixed an issue with some convert settings being lost after reset (EVC-112)
  - Fixed some issues related to sessions not being kept alive correctly, leaving Client in a mixed state where it's partially logged out (EVA-54, EVC-282)

Version 0.1.1
  - Now has UI to show when a new version is available
  - Improved camera panning to move based on hovered point (EVA-289)
  - UDS, UDG, SSF and UDM files are immediately added to scene and then processed in the background
  - Login and Keep alive are handled in the background with better error messages (EVA-388)
  - Watermarks are now only submitted to the GPU when required (speeds up UDS load times)
  - Added a mouse anchor style setting (defaults to orbit) and mouse anchor can also be turned off (EVA-410 and EVA-303)
  - Model load status is now displayed in the UI (pending, loading & failure)
  - Added standard metadata tags from Geoverse Convert (Author, Comment, Copyright and License)
  - Added a clear scene option to project menu (EVA-143 & EVA-384)
  - Added a warning when caps lock is enabled on the login screen (EVA-390)
  - Fixed issue with invert X and invert Y not affecting orbit mode
  - Fixed a number of minor memory leaks
  - Fixed an issue where background workers would occasionally get distracted and stop working
  - Fixed an issue where models with no attribute channels converted using convert were unable to be loaded in Geoverse MDM
  - When loading models you will now move to the location of the first file in the batch
  - Added new settings
    - Point Mode for different voxel modes, currently only supporting Rectangles and Cubes (EVA-169)
    - Allow mouse Interaction with map (when enabled, the mouse ray will intersect with the map; allowing orbit & pan to work on the map)
    - Added scroll wheel binding so users of Geoverse MDM can use the scroll wheel to set move speed
  - Doubled the max far plane to near plane ratio (now 20000) (EVA-396)
  - Added release notes (EVA-405)
  - Various improvements fixed via a VDK update
    - CSV total points are updated at end of processing (EVA-362)
    - Improved error detection during initial connection process
    - UDS files are unlocked in the OS after being removed from the scene (Resolves EVA-382)
  - Changed our version numbering system, now [Major].[Minor].[Revision].[BuildID]

Version 0.1.0
  - Initial Public Release
