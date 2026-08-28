#include <QGuiApplication>
#include <QFile>
#include <QQmlContext>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
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
