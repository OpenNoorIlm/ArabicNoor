#include "PrayerTimesBackend.h"
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrlQuery>
PrayerTimesBackend::PrayerTimesBackend(QObject *p) : QObject(p) {}
void PrayerTimesBackend::loadCity(const QString &city, const QString &country) {
    QUrl url("https://api.aladhan.com/v1/timingsByCity"); QUrlQuery q;
    q.addQueryItem("city", city); q.addQueryItem("country", country); q.addQueryItem("method", "1"); q.addQueryItem("school", "1"); url.setQuery(q);
    auto *reply = m_network.get(QNetworkRequest(url));
    connect(reply, &QNetworkReply::finished, this, [this, reply, city, country] {
        const auto timings = QJsonDocument::fromJson(reply->readAll()).object()["data"].toObject()["timings"].toObject(); reply->deleteLater(); m_prayers.clear();
        const QList<QPair<QString, QString>> names{{"Fajr", "الفجر"}, {"Sunrise", "الشروق"}, {"Dhuhr", "الظهر"}, {"Asr", "العصر"}, {"Maghrib", "المغرب"}, {"Isha", "العشاء"}};
        for (const auto &entry : names) { QVariantMap prayer; prayer["name"] = entry.first; prayer["arabic"] = entry.second; prayer["time"] = timings[entry.first].toString(); prayer["done"] = false; m_prayers.append(prayer); }
        m_location = city + ", " + country; emit prayersChanged(); emit locationChanged();
    });
}
