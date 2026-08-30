# NoorArabic

NoorArabic is a Qt Quick/QML learning app for Arabic, Quran reading, prayer times, and future downloadable lesson packages.

The project is designed to run from Qt Creator and Qt Design Studio, with C++ backends handling heavier work such as Quran database loading, prayer time requests, and the pending lesson-store/NAPF download API.

## Current features

- Home and subject pages for Arabic, Nahw, and Sarf.
- Quran page backed by a bundled SQLite database.
- Quran navigation by surah.
- Quran “Go to” lookup by:
  - Ayah
  - Page
  - Juz
  - Manzil
  - Ruku
  - Hizb quarter
- Prayer Times page using a C++ network backend.
- Offline decorative map/qibla display without requiring Qt Location.
- Licenses page with the project `LICENSE` file bundled into Qt resources.
- Dummy lesson-store backend for the future downloadable NAPF system.
- Desktop and Android arm64 build support.
- Initial WebAssembly support in CMake, pending the correct Emscripten version.

## Project structure

```text
NoorArabic/
├── Main.qml
├── HomePage.qml
├── QuranPage.qml
├── PrayerTimesPage.qml
├── ArabicPage.qml
├── NahwPage.qml
├── SarfPage.qml
├── SubjectLessonStore.qml
├── QuranBackend.h/.cpp
├── PrayerTimesBackend.h/.cpp
├── LessonStoreBackend.h/.cpp
├── data/
│   ├── quran.db
│   └── quran.json
├── LICENSE
├── CMakeLists.txt
└── requirements.md
```

`data/quran.db` is the database used by the app at runtime. `data/quran.json` is kept as source/reference data, but the app resource bundle uses the SQLite database for faster loading.

## Quran data

The Quran page loads only the selected surah from `quran.db` instead of parsing the whole JSON file at startup. This is much better for phones and older hardware.

The database contains:

- 6236 verses
- Surah range 1–114
- Page range 1–604
- Juz range 1–30
- Manzil range 1–7
- Ruku range 1–556
- Hizb quarter range 1–240

On first Quran use, the backend copies the bundled database from Qt resources into the app data directory so Qt SQLite can open it normally. If the bundled DB changes later, the local copy is refreshed.

## Prayer times

Prayer times are loaded through `PrayerTimesBackend`.

The app currently uses Aladhan prayer-time endpoints. If the request times out or there is no internet connection, the UI keeps its fallback/placeholder values instead of blocking the whole app.

## Lesson store and NAPF

Arabic, Nahw, and Sarf pages use `SubjectLessonStore.qml` with `LessonStoreBackend`.

The current lesson-store backend is intentionally a dummy/pending API. It already exposes the shape needed for future work:

- read lesson parts;
- list lessons for a part;
- request a NAPF download;
- report status;
- resolve local asset paths.

The planned config source is:

```text
https://raw.githubusercontent.com/OpenNoorIlm/NoorArabic-DownloadStore/main/config.yml
```

NAPF is planned as a custom package format: effectively a `.tar.xz` archive with a project-specific extension. The app should eventually download, validate, unpack, and run or load the correct platform content safely.

## Building

Open the folder in Qt Creator or Qt Design Studio and configure it with CMake.

For desktop:

```bash
cmake --build build/Desktop_Qt_6_11_2_Debug --target appNoorArabic
```

For Android arm64:

```bash
cmake --build build/Qt_6_11_2_for_Android_arm64_v8a_Debug --target appNoorArabic_prepare_apk_dir
```

See [requirements.md](requirements.md) for full toolchain requirements.

## Notes for Qt Creator vs Qt Design Studio

Qt Design Studio can preview/run designs with its own reduced Qt environment. Qt Creator uses the configured kit and runtime imports. If the UI looks different between them, check:

- the active Qt kit;
- available fonts and emoji fonts;
- `QML_IMPORT_PATH`;
- Qt Quick Controls style;
- whether Design Studio-only imports accidentally entered app QML.

The app code avoids `QtQuick.Studio.*` imports in main runtime QML so it can run from Qt Creator and Android builds.

## License

NoorArabic is licensed under the MIT License. See [LICENSE](LICENSE).
