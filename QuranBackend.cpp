#include "QuranBackend.h"

#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

QuranBackend::QuranBackend(QObject *parent)
    : QObject(parent)
{
}

void QuranBackend::loadSurah(int number)
{
    if (number < 1 || number > 114) {
        setError(tr("Surah number must be between 1 and 114."));
        return;
    }

    setError(QString());
    setLoading(true);
    m_verses.clear();
    emit versesChanged();

    const QUrl url(QStringLiteral("https://api.alquran.cloud/v1/surah/%1/quran-uthmani").arg(number));
    auto *reply = m_network.get(QNetworkRequest(url));

    connect(reply, &QNetworkReply::finished, this, [this, reply] {
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
            setError(tr("Could not read Quran API response."));
            return;
        }

        const QJsonObject root = document.object();
        const QJsonObject data = root.value(QStringLiteral("data")).toObject();
        const QJsonArray ayahs = data.value(QStringLiteral("ayahs")).toArray();

        QVariantList nextVerses;
        nextVerses.reserve(ayahs.size());
        for (const QJsonValue &ayahValue : ayahs) {
            const QJsonObject ayah = ayahValue.toObject();
            QVariantMap verse;
            verse.insert(QStringLiteral("num"), ayah.value(QStringLiteral("numberInSurah")).toInt());
            verse.insert(QStringLiteral("arabic"), ayah.value(QStringLiteral("text")).toString());
            verse.insert(QStringLiteral("source"), QStringLiteral("Al Quran Cloud"));
            nextVerses.append(verse);
        }

        m_verses = nextVerses;
        emit versesChanged();
        setLoading(false);
    });
}

void QuranBackend::setLoading(bool loading)
{
    if (m_loading == loading)
        return;

    m_loading = loading;
    emit loadingChanged();
}

void QuranBackend::setError(const QString &error)
{
    if (m_error == error)
        return;

    m_error = error;
    emit errorChanged();
}
