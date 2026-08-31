#include "SettingsBackend.h"

#include <QSettings>
#include <QStringList>
#include <QVariant>

namespace {

constexpr auto kDarkMode = "appearance/darkMode";
constexpr auto kAccentColor = "appearance/accentColor";
constexpr auto kFontSize = "appearance/fontSize";
constexpr auto kArabicFont = "appearance/arabicFont";
constexpr auto kDefaultTranslation = "quran/defaultTranslation";
constexpr auto kShowTafsir = "quran/showTafsir";
constexpr auto kShowTransliteration = "quran/showTransliteration";
constexpr auto kArabicScript = "quran/arabicScript";
constexpr auto kAutoScrollSpeed = "quran/autoScrollSpeed";
constexpr auto kCalculationMethod = "prayer/calculationMethod";
constexpr auto kAsrMethod = "prayer/asrMethod";
constexpr auto kLocation = "prayer/location";
constexpr auto kPrayerNotifications = "prayer/notifications";
constexpr auto kAdhanSound = "prayer/adhanSound";
constexpr auto kAppLanguage = "region/appLanguage";
constexpr auto kHijriOffset = "region/hijriOffset";

QSettings settings()
{
    return QSettings(QStringLiteral("OpenNoorIlm"), QStringLiteral("NoorArabic"));
}

QString nextValue(const QString &current, const QStringList &values)
{
    const int index = values.indexOf(current);
    if (index < 0 || index + 1 >= values.size())
        return values.first();

    return values.at(index + 1);
}

} // namespace

SettingsBackend::SettingsBackend(QObject *parent)
    : QObject(parent)
{
}

bool SettingsBackend::darkMode() const
{
    return boolValue(QString::fromLatin1(kDarkMode), true);
}

QString SettingsBackend::accentColor() const
{
    return stringValue(QString::fromLatin1(kAccentColor), QStringLiteral("#c9a84c"));
}

QString SettingsBackend::fontSize() const
{
    return stringValue(QString::fromLatin1(kFontSize), QStringLiteral("Medium"));
}

QString SettingsBackend::arabicFont() const
{
    return stringValue(QString::fromLatin1(kArabicFont), QStringLiteral("System default"));
}

QString SettingsBackend::defaultTranslation() const
{
    return stringValue(QString::fromLatin1(kDefaultTranslation), QStringLiteral("Kanzul Iman"));
}

bool SettingsBackend::showTafsir() const
{
    return boolValue(QString::fromLatin1(kShowTafsir), false);
}

bool SettingsBackend::showTransliteration() const
{
    return boolValue(QString::fromLatin1(kShowTransliteration), true);
}

QString SettingsBackend::arabicScript() const
{
    return stringValue(QString::fromLatin1(kArabicScript), QStringLiteral("Uthmani"));
}

QString SettingsBackend::autoScrollSpeed() const
{
    return stringValue(QString::fromLatin1(kAutoScrollSpeed), QStringLiteral("Normal"));
}

QString SettingsBackend::calculationMethod() const
{
    return stringValue(QString::fromLatin1(kCalculationMethod), QStringLiteral("Karachi"));
}

QString SettingsBackend::asrMethod() const
{
    return stringValue(QString::fromLatin1(kAsrMethod), QStringLiteral("Hanafi"));
}

QString SettingsBackend::location() const
{
    return stringValue(QString::fromLatin1(kLocation), QStringLiteral("Mysuru, Karnataka, India"));
}

bool SettingsBackend::prayerNotifications() const
{
    return boolValue(QString::fromLatin1(kPrayerNotifications), true);
}

QString SettingsBackend::adhanSound() const
{
    return stringValue(QString::fromLatin1(kAdhanSound), QStringLiteral("Makkah"));
}

QString SettingsBackend::appLanguage() const
{
    return stringValue(QString::fromLatin1(kAppLanguage), QStringLiteral("English"));
}

int SettingsBackend::hijriOffset() const
{
    return intValue(QString::fromLatin1(kHijriOffset), 0);
}

void SettingsBackend::setBool(const QString &key, bool value)
{
    if (key == QStringLiteral("darkMode"))
        setDarkMode(value);
    else if (key == QStringLiteral("showTafsir"))
        setShowTafsir(value);
    else if (key == QStringLiteral("showTransliteration"))
        setShowTransliteration(value);
    else if (key == QStringLiteral("prayerNotifications"))
        setPrayerNotifications(value);
}

void SettingsBackend::setString(const QString &key, const QString &value)
{
    const QString cleanValue = value.trimmed();
    if (cleanValue.isEmpty())
        return;

    if (key == QStringLiteral("location"))
        setValue(QString::fromLatin1(kLocation), cleanValue);
}

void SettingsBackend::cycleSetting(const QString &key)
{
    if (key == QStringLiteral("accentColor")) {
        setValue(QString::fromLatin1(kAccentColor),
                 nextValue(accentColor(), { QStringLiteral("#c9a84c"),
                                            QStringLiteral("#74d3ae"),
                                            QStringLiteral("#7aa2ff"),
                                            QStringLiteral("#e07a8d") }));
    } else if (key == QStringLiteral("fontSize")) {
        setValue(QString::fromLatin1(kFontSize),
                 nextValue(fontSize(), { QStringLiteral("Small"),
                                         QStringLiteral("Medium"),
                                         QStringLiteral("Large"),
                                         QStringLiteral("Extra Large") }));
    } else if (key == QStringLiteral("arabicFont")) {
        setValue(QString::fromLatin1(kArabicFont),
                 nextValue(arabicFont(), { QStringLiteral("System default"),
                                           QStringLiteral("Noto Naskh Arabic"),
                                           QStringLiteral("Amiri"),
                                           QStringLiteral("Scheherazade New") }));
    } else if (key == QStringLiteral("defaultTranslation")) {
        setValue(QString::fromLatin1(kDefaultTranslation),
                 nextValue(defaultTranslation(), { QStringLiteral("Kanzul Iman"),
                                                   QStringLiteral("Kanzul Irfan"),
                                                   QStringLiteral("Sahih International") }));
    } else if (key == QStringLiteral("arabicScript")) {
        setValue(QString::fromLatin1(kArabicScript),
                 nextValue(arabicScript(), { QStringLiteral("Uthmani"),
                                             QStringLiteral("Simple") }));
    } else if (key == QStringLiteral("autoScrollSpeed")) {
        setValue(QString::fromLatin1(kAutoScrollSpeed),
                 nextValue(autoScrollSpeed(), { QStringLiteral("Off"),
                                                QStringLiteral("Slow"),
                                                QStringLiteral("Normal"),
                                                QStringLiteral("Fast") }));
    } else if (key == QStringLiteral("calculationMethod")) {
        setValue(QString::fromLatin1(kCalculationMethod),
                 nextValue(calculationMethod(), { QStringLiteral("Karachi"),
                                                  QStringLiteral("Muslim World League"),
                                                  QStringLiteral("Umm al-Qura"),
                                                  QStringLiteral("Egyptian") }));
    } else if (key == QStringLiteral("asrMethod")) {
        setValue(QString::fromLatin1(kAsrMethod),
                 nextValue(asrMethod(), { QStringLiteral("Hanafi"),
                                          QStringLiteral("Standard") }));
    } else if (key == QStringLiteral("location")) {
        setValue(QString::fromLatin1(kLocation),
                 nextValue(location(), { QStringLiteral("Mysuru, Karnataka, India"),
                                         QStringLiteral("Makkah, Saudi Arabia"),
                                         QStringLiteral("Madinah, Saudi Arabia"),
                                         QStringLiteral("Delhi, India") }));
    } else if (key == QStringLiteral("adhanSound")) {
        setValue(QString::fromLatin1(kAdhanSound),
                 nextValue(adhanSound(), { QStringLiteral("Makkah"),
                                           QStringLiteral("Madinah"),
                                           QStringLiteral("None") }));
    } else if (key == QStringLiteral("appLanguage")) {
        setValue(QString::fromLatin1(kAppLanguage),
                 nextValue(appLanguage(), { QStringLiteral("English"),
                                            QStringLiteral("Arabic"),
                                            QStringLiteral("Urdu") }));
    } else if (key == QStringLiteral("hijriOffset")) {
        int nextOffset = hijriOffset() + 1;
        if (nextOffset > 2)
            nextOffset = -2;

        setValue(QString::fromLatin1(kHijriOffset), nextOffset);
    }
}

void SettingsBackend::resetAll()
{
    QSettings store = settings();
    store.clear();
    store.sync();
    emit settingsChanged();
}

void SettingsBackend::setDarkMode(bool value)
{
    setValue(QString::fromLatin1(kDarkMode), value);
}

void SettingsBackend::setShowTafsir(bool value)
{
    setValue(QString::fromLatin1(kShowTafsir), value);
}

void SettingsBackend::setShowTransliteration(bool value)
{
    setValue(QString::fromLatin1(kShowTransliteration), value);
}

void SettingsBackend::setPrayerNotifications(bool value)
{
    setValue(QString::fromLatin1(kPrayerNotifications), value);
}

QString SettingsBackend::stringValue(const QString &key, const QString &fallback) const
{
    return settings().value(key, fallback).toString();
}

bool SettingsBackend::boolValue(const QString &key, bool fallback) const
{
    return settings().value(key, fallback).toBool();
}

int SettingsBackend::intValue(const QString &key, int fallback) const
{
    return settings().value(key, fallback).toInt();
}

void SettingsBackend::setValue(const QString &key, const QVariant &value)
{
    QSettings store = settings();
    if (store.value(key) == value)
        return;

    store.setValue(key, value);
    store.sync();
    emit settingsChanged();
}
