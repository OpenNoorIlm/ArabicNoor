# NoorArabic requirements

This file lists the tools, Qt modules, platform requirements, and runtime requirements needed to build and run NoorArabic.

## Required Qt version

- Qt 6.10 or newer is required by `qt_standard_project_setup(REQUIRES 6.10)`.
- The current local setup has been tested with Qt 6.11.2.

## Required Qt modules

The CMake project requires:

- `Qt6::Core`
- `Qt6::Quick`
- `Qt6::QuickControls2`
- `Qt6::Network`
- `Qt6::Sql`

The QML side uses:

- `QtQuick`
- `QtQuick.Controls`
- `QtQuick.Timeline`

The app should not depend on `QtQuick.Studio.Components` or `QtQuick.Studio.DesignEffects` at runtime.

## Required C++ standard

- A C++ compiler supported by Qt 6.
- CMake sets `CMAKE_CXX_STANDARD_REQUIRED ON`.

## Build tools

Required:

- CMake 3.16 or newer
- Ninja or Make
- A Qt 6 kit configured in Qt Creator or Qt Design Studio
- C++ compiler for the target platform

Recommended:

- Qt Creator for C++ backend work and Android/WebAssembly builds
- Qt Design Studio for visual QML editing

## Desktop Linux requirements

Required:

- Qt 6 desktop kit, for example `gcc_64`
- Working OpenGL/Vulkan/graphics stack supported by Qt Quick
- SQLite SQL driver plugin from Qt

Runtime notes:

- Quran data is bundled as `data/quran.db`.
- The app copies the bundled DB to the writable app data folder before opening it with SQLite.
- Prayer time loading requires internet access.

## Android requirements

Required:

- Qt for Android kit matching the target ABI
- Android SDK
- Android NDK supported by the installed Qt version
- JDK supported by Qt Android deployment tools
- A valid Android device or emulator selected in Qt Creator

Current Android settings:

- Package name: `org.opennoorilm.noorarabic`
- App name: `NoorArabic`
- Tested target ABI: `arm64-v8a`

Required Android permissions:

- `android.permission.INTERNET`
- `android.permission.ACCESS_NETWORK_STATE`

Important Android notes:

- If Qt Creator says `No valid deployment device is set`, select a real device/emulator in the Android kit deployment settings.
- The SQLite driver must be packaged. Qt deployment normally includes it automatically because the app links `Qt6::Sql`.
- Do not keep downloaded lesson project trees inside the source root if they contain extra QML imports. Android deployment scans QML paths and may warn about those imported lesson files.

## WebAssembly requirements

Required:

- Qt WebAssembly kit
- Emscripten version matching the Qt WebAssembly build

For the current Qt 6.11.2 `wasm_multithread` kit:

- Required Emscripten: `4.0.7`
- Known wrong active version from local logs: `6.0.2`

If CMake fails with an Emscripten mismatch, install and activate the exact version required by Qt:

```bash
/home/bismillah/emsdk/emsdk install 4.0.7
/home/bismillah/emsdk/emsdk activate 4.0.7
source /home/bismillah/emsdk/emsdk_env.sh
```

Then restart Qt Creator or reconfigure the WebAssembly kit so it sees the corrected environment.

Current CMake WebAssembly flags:

- `NOORARABIC_WASM=1`
- `-s FETCH=1`
- `-s ALLOW_MEMORY_GROWTH=1`
- `-s MAXIMUM_MEMORY=1GB`

## Runtime network requirements

Prayer times require internet access.

Current prayer time backend uses Aladhan API endpoints. Network timeouts should not block the whole app, but fresh prayer data will not appear until a request succeeds.

## Runtime storage requirements

The app needs a writable application-data or cache directory for:

- the copied `quran.db`;
- future downloaded lesson/NAPF content;
- future user progress/bookmarks/settings data.

Qt resolves this through `QStandardPaths`.

## Bundled data requirements

Required runtime resource:

- `data/quran.db`

Bundled legal resource:

- `LICENSE`

Reference/source data currently kept in the repository:

- `data/quran.json`

The JSON file is not intended to be loaded by the app at runtime anymore.

## Future NAPF requirements

The NAPF system is pending. Planned requirements:

- YAML config download/parsing from the NoorArabic download store.
- Secure download of `.napf` packages.
- Package validation before unpacking.
- Safe extraction path handling.
- Platform-specific content selection.
- A C++ API for lessons needing 3D rendering, animations, randomized questions, progress tracking, and tests.

NAPF packages should not blindly execute arbitrary downloaded binaries. A safer long-term design is to load declared lesson assets/scripts through a controlled app API.

## Troubleshooting

### `module "QtQuick.Studio.Components" is not installed`

Runtime QML should not import Design Studio-only modules. Remove those imports from app QML or keep them only inside design-only content.

### `appNoorArabic.qmltypes does not exist`

Reconfigure and rebuild the project from Qt Creator. Qt should generate the file beside the module `qmldir`. An empty `.qmltypes` file can be normal if there are no registered QML C++ types to describe.

### WebAssembly Emscripten mismatch

Use the exact Emscripten version printed by Qt’s CMake error. For Qt 6.11.2 `wasm_multithread`, use Emscripten `4.0.7`.

### Android deploy says no valid device

Start an emulator or connect a physical Android device with USB debugging enabled, then select it in Qt Creator before deploying.
