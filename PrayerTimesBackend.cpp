#include "PrayerTimesBackend.h"

#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrlQuery>

#include <QDate>
#include <QJsonArray>
#include <QTime>

PrayerTimesBackend::PrayerTimesBackend(QObject *parent)
    : QObject(parent)
{
}

void PrayerTimesBackend::loadCity(const QString &city, const QString &country)
{
    QUrl url(QStringLiteral("https://api.aladhan.com/v1/timingsByCity"));
    QUrlQuery query;
    query.addQueryItem(QStringLiteral("city"), city.trimmed());
    query.addQueryItem(QStringLiteral("country"), country.trimmed());
    query.addQueryItem(QStringLiteral("method"), QStringLiteral("1"));
    query.addQueryItem(QStringLiteral("school"), QStringLiteral("1"));
    url.setQuery(query);

    fetch(url, city.trimmed() + QStringLiteral(", ") + country.trimmed());
}

void PrayerTimesBackend::loadAddress(const QString &address)
{
    const QString trimmedAddress = address.trimmed();
    if (trimmedAddress.isEmpty())
        return;

    QUrl url(QStringLiteral("https://api.aladhan.com/v1/timingsByAddress"));
    QUrlQuery query;
    query.addQueryItem(QStringLiteral("address"), trimmedAddress);
    query.addQueryItem(QStringLiteral("method"), QStringLiteral("1"));
    query.addQueryItem(QStringLiteral("school"), QStringLiteral("1"));
    url.setQuery(query);

    fetch(url, trimmedAddress);
}

void PrayerTimesBackend::fetch(const QUrl &url, const QString &displayLocation)
{
    setError(QString());
    setLoading(true);

    auto *reply = m_network.get(QNetworkRequest(url));
    connect(reply, &QNetworkReply::finished, this, [this, reply, displayLocation] {
        const QByteArray body = reply->readAll();
        const QNetworkReply::NetworkError networkError = reply->error();
        const QString networkErrorText = reply->errorString();
        reply->deleteLater();

        if (networkError != QNetworkReply::NoError) {
            setLoading(false);
            setError(networkErrorText);
            return;
        }

        QJsonParseError parseError;
        const QJsonDocument document = QJsonDocument::fromJson(body, &parseError);
        if (parseError.error != QJsonParseError::NoError || !document.isObject()) {
            setLoading(false);
            setError(tr("Could not read prayer-time API response."));
            return;
        }

        const QJsonObject data = document.object().value(QStringLiteral("data")).toObject();
        const QJsonObject timings = data.value(QStringLiteral("timings")).toObject();
        const QJsonObject date = data.value(QStringLiteral("date")).toObject();

        const QList<QPair<QString, QString>> names{
            {QStringLiteral("Fajr"), QStringLiteral("الفجر")},
            {QStringLiteral("Sunrise"), QStringLiteral("الشروق")},
            {QStringLiteral("Dhuhr"), QStringLiteral("الظهر")},
            {QStringLiteral("Asr"), QStringLiteral("العصر")},
            {QStringLiteral("Maghrib"), QStringLiteral("المغرب")},
            {QStringLiteral("Isha"), QStringLiteral("العشاء")}
        };
        const QHash<QString, QString> icons{
            {QStringLiteral("Fajr"), QStringLiteral("moon")},
            {QStringLiteral("Sunrise"), QStringLiteral("sunrise")},
            {QStringLiteral("Dhuhr"), QStringLiteral("sun")},
            {QStringLiteral("Asr"), QStringLiteral("cloud-sun")},
            {QStringLiteral("Maghrib"), QStringLiteral("sunset")},
            {QStringLiteral("Isha"), QStringLiteral("night")}
        };

        const QTime now = QTime::currentTime();
        QVariantList nextPrayers;
        nextPrayers.reserve(names.size());

        for (const auto &entry : names) {
            const QString rawTime = timings.value(entry.first).toString().section(' ', 0, 0);
            const QTime prayerTime = QTime::fromString(rawTime, QStringLiteral("HH:mm"));

            QVariantMap prayer;
            prayer.insert(QStringLiteral("name"), entry.first);
            prayer.insert(QStringLiteral("arabic"), entry.second);
            prayer.insert(QStringLiteral("time"), rawTime);
            prayer.insert(QStringLiteral("icon"), icons.value(entry.first));
            prayer.insert(QStringLiteral("done"), prayerTime.isValid() && prayerTime < now);
            nextPrayers.append(prayer);
        }

        m_prayers = nextPrayers;
        emit prayersChanged();

        setLocation(displayLocation);
        setGregorianDate(date.value(QStringLiteral("readable")).toString());

        const QJsonObject hijri = date.value(QStringLiteral("hijri")).toObject();
        setHijriDate(hijri.value(QStringLiteral("day")).toString()
                     + QStringLiteral(" ")
                     + hijri.value(QStringLiteral("month")).toObject().value(QStringLiteral("en")).toString()
                     + QStringLiteral(" ")
                     + hijri.value(QStringLiteral("year")).toString()
                     + QStringLiteral(" AH"));
        setLoading(false);
    });
}

void PrayerTimesBackend::setLocation(const QString &location)
{
    if (m_location == location)
        return;

    m_location = location;
    emit locationChanged();
}

void PrayerTimesBackend::setHijriDate(const QString &hijriDate)
{
    if (m_hijriDate == hijriDate)
        return;

    m_hijriDate = hijriDate;
    emit hijriDateChanged();
}

void PrayerTimesBackend::setGregorianDate(const QString &gregorianDate)
{
    if (m_gregorianDate == gregorianDate)
        return;

    m_gregorianDate = gregorianDate;
    emit gregorianDateChanged();
}

void PrayerTimesBackend::setError(const QString &error)
{
    if (m_error == error)
        return;

    m_error = error;
    emit errorChanged();
}

void PrayerTimesBackend::setLoading(bool loading)
{
    if (m_loading == loading)
        return;

    m_loading = loading;
    emit loadingChanged();
}
