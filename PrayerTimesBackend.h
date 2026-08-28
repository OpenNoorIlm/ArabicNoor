#pragma once
#include <QObject>
#include <QVariantList>
#include <QNetworkAccessManager>
class PrayerTimesBackend : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList prayers READ prayers NOTIFY prayersChanged)
    Q_PROPERTY(QString location READ location NOTIFY locationChanged)
public:
    explicit PrayerTimesBackend(QObject *parent = nullptr);
    QVariantList prayers() const { return m_prayers; }
    QString location() const { return m_location; }
    Q_INVOKABLE void loadCity(const QString &city, const QString &country = "India");
signals:
    void prayersChanged(); void locationChanged();
private:
    QNetworkAccessManager m_network; QVariantList m_prayers; QString m_location;
};
