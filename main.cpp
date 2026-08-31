#include <QGuiApplication>
#include <QFile>
#include <QDebug>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include "QuranBackend.h"
#include "PrayerTimesBackend.h"
#include "LessonStoreBackend.h"
#include "SettingsBackend.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    QuranBackend quranBackend;
    PrayerTimesBackend prayerTimesBackend;
    LessonStoreBackend lessonStoreBackend;
    SettingsBackend settingsBackend;
    engine.rootContext()->setContextProperty("quranBackend", &quranBackend);
    engine.rootContext()->setContextProperty("prayerTimesBackend", &prayerTimesBackend);
    engine.rootContext()->setContextProperty("lessonStoreBackend", &lessonStoreBackend);
    engine.rootContext()->setContextProperty("settingsBackend", &settingsBackend);
    qDebug() << "NoorArabic C++ backends registered";
#if !defined(Q_OS_ANDROID) && !defined(Q_OS_WASM)
    engine.addImportPath(QStringLiteral(QDS_QML_IMPORT_PATH));
    engine.addImportPath(QStringLiteral(QT_QML_IMPORT_PATH));
#endif
    QFile licenseFile(":/qt/qml/NoorArabic/LICENSE");
    if (!licenseFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        licenseFile.setFileName(":/LICENSE");
        if (!licenseFile.open(QIODevice::ReadOnly | QIODevice::Text))
            return -1;
    }
    engine.rootContext()->setContextProperty("appLicenseText", QString::fromUtf8(licenseFile.readAll()));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("NoorArabic", "Main");

    return QGuiApplication::exec();
}
