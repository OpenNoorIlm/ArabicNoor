#pragma once
#include <QObject>
#include <QVariantList>
#include <QNetworkAccessManager>
class PrayerTimesBackend : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList prayers READ prayers NOTIFY prayersChanged)
    Q_PROPERTY(QString location READ location NOTIFY locationChanged)
    Q_PROPERTY(QString hijriDate READ hijriDate NOTIFY hijriDateChanged)
    Q_PROPERTY(QString gregorianDate READ gregorianDate NOTIFY gregorianDateChanged)
    Q_PROPERTY(QString error READ error NOTIFY errorChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)
public:
    explicit PrayerTimesBackend(QObject *parent = nullptr);
    QVariantList prayers() const { return m_prayers; }
    QString location() const { return m_location; }
    QString hijriDate() const { return m_hijriDate; }
    QString gregorianDate() const { return m_gregorianDate; }
    QString error() const { return m_error; }
    bool loading() const { return m_loading; }
    Q_INVOKABLE void loadCity(const QString &city, const QString &country = "India");
    Q_INVOKABLE void loadAddress(const QString &address);
signals:
    void prayersChanged();
    void locationChanged();
    void hijriDateChanged();
    void gregorianDateChanged();
    void errorChanged();
    void loadingChanged();
private:
    void fetch(const QUrl &url, const QString &displayLocation);
    void setLocation(const QString &location);
    void setHijriDate(const QString &hijriDate);
    void setGregorianDate(const QString &gregorianDate);
    void setError(const QString &error);
    void setLoading(bool loading);

    QNetworkAccessManager m_network;
    QVariantList m_prayers;
    QString m_location;
    QString m_hijriDate;
    QString m_gregorianDate;
    QString m_error;
    bool m_loading = false;
};
