cmake_minimum_required(VERSION 3.16)

project(NoorArabic VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 Network Sql)

qt_standard_project_setup(REQUIRES 6.10)

# Content of downloaded design from Figma to Qt or similar
if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/importedcontent/CMakeLists.txt")
    add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/importedcontent)
endif()

qt_add_executable(appNoorArabic
    main.cpp
    QuranBackend.h
    QuranBackend.cpp
    PrayerTimesBackend.h
    PrayerTimesBackend.cpp
    LessonStoreBackend.h
    LessonStoreBackend.cpp
    SettingsBackend.h
    SettingsBackend.cpp
)

qt_add_qml_module(appNoorArabic
    URI NoorArabic
    QML_FILES
        Main.qml
        HomePage.qml
        SubjectsPage.qml
        QuranPage.qml
        PrayerTimesPage.qml
        LessonsPage.qml
        BookmarksPage.qml
        SettingsPage.qml
        SarfPage.qml
        NahwPage.qml
        ArabicPage.qml
        AboutSarf.qml
        AboutNahw.qml
        AboutArabic.qml
        AnimBlock.qml
        ContentDivider.qml
        SettingRow.qml
        SettingSectionHeader.qml
        LicensesPage.qml
        LicenseTextPage.qml
        SubjectLessonStore.qml
    RESOURCES
        LICENSE
        data/quran.db
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appNoorArabic PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appNoorArabic
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

if(ANDROID)
    set_target_properties(appNoorArabic PROPERTIES
        QT_ANDROID_PACKAGE_NAME "org.opennoorilm.noorarabic"
        QT_ANDROID_APP_NAME "NoorArabic"
    )

    qt_add_android_permission(appNoorArabic
        NAME android.permission.INTERNET
    )
    qt_add_android_permission(appNoorArabic
        NAME android.permission.ACCESS_NETWORK_STATE
    )
endif()

if(EMSCRIPTEN)
    target_compile_definitions(appNoorArabic PRIVATE
        NOORARABIC_WASM=1
    )

    target_link_options(appNoorArabic PRIVATE
        "SHELL:-s FETCH=1"
        "SHELL:-s ALLOW_MEMORY_GROWTH=1"
        "SHELL:-s MAXIMUM_MEMORY=1GB"
    )
endif()

target_link_libraries(appNoorArabic
    PRIVATE Qt6::Core Qt6::Quick Qt6::QuickControls2 Qt6::Network Qt6::Sql
)

if(NOT ANDROID AND NOT EMSCRIPTEN)
    set(QDS_QML_PATH "/home/bismillah/Qt/Tools/QtDesignStudio-4.8.3-preview/qt6_design_studio_reduced_version/qml")
    set(QT_QML_PATH "/home/bismillah/Qt/6.11.2/gcc_64/qml")

    target_compile_definitions(appNoorArabic PRIVATE
        QDS_QML_IMPORT_PATH="${QDS_QML_PATH}"
        QT_QML_IMPORT_PATH="${QT_QML_PATH}"
    )

    set_property(TARGET appNoorArabic PROPERTY
        ENVIRONMENT "QML_IMPORT_PATH=${QT_QML_PATH}:${QDS_QML_PATH}"
    )
endif()

install(TARGETS appNoorArabic
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
