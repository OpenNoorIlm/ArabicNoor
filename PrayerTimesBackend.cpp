#include "PrayerTimesBackend.h"

#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrlQuery>

#include <QDate>
#include <QDebug>
#include <QHash>
#include <QJsonArray>
#include <QTime>
#include <QtMath>

namespace {

QString formatCoordinate(double value, const QString &positiveSuffix, const QString &negativeSuffix)
{
    const QString suffix = value >= 0 ? positiveSuffix : negativeSuffix;
    return QStringLiteral("%1 %2").arg(qAbs(value), 0, 'f', 4).arg(suffix);
}

QString calculateQiblaDirection(double latitude, double longitude)
{
    static constexpr double kaabaLatitude = 21.422487;
    static constexpr double kaabaLongitude = 39.826206;

    const double latitudeRadians = qDegreesToRadians(latitude);
    const double kaabaLatitudeRadians = qDegreesToRadians(kaabaLatitude);
    const double longitudeDifferenceRadians = qDegreesToRadians(kaabaLongitude - longitude);

    const double y = qSin(longitudeDifferenceRadians);
    const double x = qCos(latitudeRadians) * qTan(kaabaLatitudeRadians)
                     - qSin(latitudeRadians) * qCos(longitudeDifferenceRadians);

    double direction = qRadiansToDegrees(qAtan2(y, x));
    if (direction < 0)
        direction += 360.0;

    return QStringLiteral("%1°").arg(direction, 0, 'f', 0);
}

} // namespace

PrayerTimesBackend::PrayerTimesBackend(QObject *parent)
    : QObject(parent)
{
    loadFallback(QStringLiteral("Mysuru, Karnataka, India"));
}

void PrayerTimesBackend::loadCity(const QString &city, const QString &country)
{
    qDebug() << "PrayerTimesBackend::loadCity called with" << city << country;

    const QString datePath = QDate::currentDate().toString(QStringLiteral("dd-MM-yyyy"));
    QUrl url(QStringLiteral("https://api.aladhan.com/v1/timingsByCity/%1").arg(datePath));
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

    qDebug() << "PrayerTimesBackend::loadAddress called with" << trimmedAddress;

    const QString datePath = QDate::currentDate().toString(QStringLiteral("dd-MM-yyyy"));
    QUrl url(QStringLiteral("https://api.aladhan.com/v1/timingsByAddress/%1").arg(datePath));
    QUrlQuery query;
    query.addQueryItem(QStringLiteral("address"), trimmedAddress);
    query.addQueryItem(QStringLiteral("method"), QStringLiteral("1"));
    query.addQueryItem(QStringLiteral("school"), QStringLiteral("1"));
    url.setQuery(query);

    fetch(url, trimmedAddress);
}

void PrayerTimesBackend::fetch(const QUrl &url, const QString &displayLocation)
{
    qDebug() << "PrayerTimesBackend fetching" << url;

    setError(QString());
    loadFallback(displayLocation);
    setLoading(true);

    QNetworkRequest request(url);
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::NoLessSafeRedirectPolicy);
    request.setTransferTimeout(15000);

    auto *reply = m_network.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply, displayLocation] {
        const QByteArray body = reply->readAll();
        const QNetworkReply::NetworkError networkError = reply->error();
        const QString networkErrorText = reply->errorString();
        reply->deleteLater();

        if (networkError != QNetworkReply::NoError) {
            setLoading(false);
            setError(networkErrorText);
            qWarning() << "PrayerTimesBackend request failed:" << networkErrorText;
            return;
        }

        QJsonParseError parseError;
        const QJsonDocument document = QJsonDocument::fromJson(body, &parseError);
        if (parseError.error != QJsonParseError::NoError || !document.isObject()) {
            setLoading(false);
            setError(tr("Could not read prayer-time API response."));
            qWarning() << "PrayerTimesBackend JSON parse failed:" << parseError.errorString();
            return;
        }

        const QJsonObject root = document.object();
        if (root.value(QStringLiteral("code")).toInt() != 200) {
            setLoading(false);
            setError(root.value(QStringLiteral("status")).toString(tr("Prayer-time API request failed.")));
            qWarning() << "PrayerTimesBackend API status failed:" << root.value(QStringLiteral("status")).toString();
            return;
        }

        const QJsonObject data = root.value(QStringLiteral("data")).toObject();
        const QJsonObject timings = data.value(QStringLiteral("timings")).toObject();
        const QJsonObject date = data.value(QStringLiteral("date")).toObject();
        const QJsonObject meta = data.value(QStringLiteral("meta")).toObject();
        if (timings.isEmpty()) {
            setLoading(false);
            setError(tr("Prayer-time API returned no timings."));
            qWarning() << "PrayerTimesBackend API returned no timings";
            return;
        }

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

        setCoordinates(meta.value(QStringLiteral("latitude")).toDouble(),
                       meta.value(QStringLiteral("longitude")).toDouble());
        setLoading(false);
        qDebug() << "PrayerTimesBackend loaded prayers:" << m_prayers.size();
        qDebug() << "PrayerTimesBackend coordinates:" << m_latitude << m_longitude << "qibla" << m_qiblaDirection;
    });
}

void PrayerTimesBackend::loadFallback(const QString &displayLocation)
{
    const QList<QVariantMap> fallbackRows{
        {{QStringLiteral("name"), QStringLiteral("Fajr")},
         {QStringLiteral("arabic"), QStringLiteral("الفجر")},
         {QStringLiteral("time"), QStringLiteral("05:01")},
         {QStringLiteral("icon"), QStringLiteral("moon")}},
        {{QStringLiteral("name"), QStringLiteral("Sunrise")},
         {QStringLiteral("arabic"), QStringLiteral("الشروق")},
         {QStringLiteral("time"), QStringLiteral("06:13")},
         {QStringLiteral("icon"), QStringLiteral("sunrise")}},
        {{QStringLiteral("name"), QStringLiteral("Dhuhr")},
         {QStringLiteral("arabic"), QStringLiteral("الظهر")},
         {QStringLiteral("time"), QStringLiteral("12:25")},
         {QStringLiteral("icon"), QStringLiteral("sun")}},
        {{QStringLiteral("name"), QStringLiteral("Asr")},
         {QStringLiteral("arabic"), QStringLiteral("العصر")},
         {QStringLiteral("time"), QStringLiteral("16:46")},
         {QStringLiteral("icon"), QStringLiteral("cloud-sun")}},
        {{QStringLiteral("name"), QStringLiteral("Maghrib")},
         {QStringLiteral("arabic"), QStringLiteral("المغرب")},
         {QStringLiteral("time"), QStringLiteral("18:37")},
         {QStringLiteral("icon"), QStringLiteral("sunset")}},
        {{QStringLiteral("name"), QStringLiteral("Isha")},
         {QStringLiteral("arabic"), QStringLiteral("العشاء")},
         {QStringLiteral("time"), QStringLiteral("19:48")},
         {QStringLiteral("icon"), QStringLiteral("night")}}
    };

    const QTime now = QTime::currentTime();
    QVariantList fallbackPrayers;
    fallbackPrayers.reserve(fallbackRows.size());

    for (QVariantMap prayer : fallbackRows) {
        const QTime prayerTime = QTime::fromString(prayer.value(QStringLiteral("time")).toString(), QStringLiteral("HH:mm"));
        prayer.insert(QStringLiteral("done"), prayerTime.isValid() && prayerTime < now);
        fallbackPrayers.append(prayer);
    }

    m_prayers = fallbackPrayers;
    emit prayersChanged();

    setLocation(displayLocation);
    setGregorianDate(QDate::currentDate().toString(QStringLiteral("dd MMM yyyy")));
    setHijriDate(QStringLiteral("Offline Hijri date unavailable"));
    setCoordinates(12.2958, 76.6394);
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

void PrayerTimesBackend::setCoordinates(double latitude, double longitude)
{
    const QString nextLatitude = formatCoordinate(latitude, QStringLiteral("N"), QStringLiteral("S"));
    const QString nextLongitude = formatCoordinate(longitude, QStringLiteral("E"), QStringLiteral("W"));
    const QString nextQiblaDirection = calculateQiblaDirection(latitude, longitude);

    if (m_latitude == nextLatitude && m_longitude == nextLongitude && m_qiblaDirection == nextQiblaDirection)
        return;

    m_latitude = nextLatitude;
    m_longitude = nextLongitude;
    m_qiblaDirection = nextQiblaDirection;
    emit coordinatesChanged();
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
