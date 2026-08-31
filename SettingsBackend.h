#pragma once

#include <QObject>
#include <QString>
#include <QVariant>

class SettingsBackend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool darkMode READ darkMode WRITE setDarkMode NOTIFY settingsChanged)
    Q_PROPERTY(QString accentColor READ accentColor NOTIFY settingsChanged)
    Q_PROPERTY(QString fontSize READ fontSize NOTIFY settingsChanged)
    Q_PROPERTY(QString arabicFont READ arabicFont NOTIFY settingsChanged)
    Q_PROPERTY(QString defaultTranslation READ defaultTranslation NOTIFY settingsChanged)
    Q_PROPERTY(bool showTafsir READ showTafsir WRITE setShowTafsir NOTIFY settingsChanged)
    Q_PROPERTY(bool showTransliteration READ showTransliteration WRITE setShowTransliteration NOTIFY settingsChanged)
    Q_PROPERTY(QString arabicScript READ arabicScript NOTIFY settingsChanged)
    Q_PROPERTY(QString autoScrollSpeed READ autoScrollSpeed NOTIFY settingsChanged)
    Q_PROPERTY(QString calculationMethod READ calculationMethod NOTIFY settingsChanged)
    Q_PROPERTY(QString asrMethod READ asrMethod NOTIFY settingsChanged)
    Q_PROPERTY(QString location READ location NOTIFY settingsChanged)
    Q_PROPERTY(bool prayerNotifications READ prayerNotifications WRITE setPrayerNotifications NOTIFY settingsChanged)
    Q_PROPERTY(QString adhanSound READ adhanSound NOTIFY settingsChanged)
    Q_PROPERTY(QString appLanguage READ appLanguage NOTIFY settingsChanged)
    Q_PROPERTY(int hijriOffset READ hijriOffset NOTIFY settingsChanged)

public:
    explicit SettingsBackend(QObject *parent = nullptr);

    bool darkMode() const;
    QString accentColor() const;
    QString fontSize() const;
    QString arabicFont() const;
    QString defaultTranslation() const;
    bool showTafsir() const;
    bool showTransliteration() const;
    QString arabicScript() const;
    QString autoScrollSpeed() const;
    QString calculationMethod() const;
    QString asrMethod() const;
    QString location() const;
    bool prayerNotifications() const;
    QString adhanSound() const;
    QString appLanguage() const;
    int hijriOffset() const;

    Q_INVOKABLE void setBool(const QString &key, bool value);
    Q_INVOKABLE void setString(const QString &key, const QString &value);
    Q_INVOKABLE void cycleSetting(const QString &key);
    Q_INVOKABLE void resetAll();

public slots:
    void setDarkMode(bool value);
    void setShowTafsir(bool value);
    void setShowTransliteration(bool value);
    void setPrayerNotifications(bool value);

signals:
    void settingsChanged();

private:
    QString stringValue(const QString &key, const QString &fallback) const;
    bool boolValue(const QString &key, bool fallback) const;
    int intValue(const QString &key, int fallback) const;
    void setValue(const QString &key, const QVariant &value);
};
