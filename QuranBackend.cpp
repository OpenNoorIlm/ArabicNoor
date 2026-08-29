#include "QuranBackend.h"

#include <QFile>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>

QuranBackend::QuranBackend(QObject *parent)
    : QObject(parent)
{
}

void QuranBackend::loadSurah(int number)
{
    qDebug() << "QuranBackend::loadSurah called with surah" << number;

    if (number < 1 || number > 114) {
        setError(tr("Surah number must be between 1 and 114."));
        return;
    }

    setError(QString());
    setLoading(true);
    m_verses.clear();
    emit versesChanged();

    if (!loadData()) {
        setLoading(false);
        return;
    }

    mergeEdition(QStringLiteral("Quran Uthmani (Arabic Text)"), number, QStringLiteral("arabic"));
    mergeEdition(QStringLiteral("Kanzul Iman (Urdu Translation)"), number, QStringLiteral("kanzul"));
    mergeEdition(QStringLiteral("Tafsir al-Jalalayn (Arabic Tafsir)"), number, QStringLiteral("jalayn"));

    for (QVariant &verseValue : m_verses) {
        QVariantMap verse = verseValue.toMap();
        verse.insert(QStringLiteral("irfan"), tr("Kanzul Irfan is not present in bundled quran.json."));
        verseValue = verse;
    }

    if (m_verses.isEmpty())
        setError(tr("No verses found for this surah in bundled quran.json."));

    setLoading(false);
    emit versesChanged();
    qDebug() << "QuranBackend loaded local verses:" << m_verses.size();
}

bool QuranBackend::loadData()
{
    if (m_dataLoaded)
        return true;

    QFile file(QStringLiteral(":/qt/qml/NoorArabic/data/quran.json"));
    if (!file.open(QIODevice::ReadOnly)) {
        file.setFileName(QStringLiteral(":/data/quran.json"));
        if (!file.open(QIODevice::ReadOnly)) {
            setError(tr("Could not open bundled quran.json."));
            qWarning() << "QuranBackend could not open quran.json";
            return false;
        }
    }

    QJsonParseError parseError;
    m_document = QJsonDocument::fromJson(file.readAll(), &parseError);
    if (parseError.error != QJsonParseError::NoError || !m_document.isObject()) {
        setError(tr("Could not parse bundled quran.json."));
        qWarning() << "QuranBackend JSON parse failed:" << parseError.errorString();
        return false;
    }

    m_dataLoaded = true;
    qDebug() << "QuranBackend loaded bundled quran.json";
    return true;
}

QJsonArray QuranBackend::ayahsForEdition(const QString &editionName, int surahNumber) const
{
    const QJsonObject edition = m_document.object().value(editionName).toObject();
    const QJsonArray surahs = edition.value(QStringLiteral("data")).toObject().value(QStringLiteral("surahs")).toArray();

    for (const QJsonValue &surahValue : surahs) {
        const QJsonObject surah = surahValue.toObject();
        if (surah.value(QStringLiteral("number")).toInt() == surahNumber)
            return surah.value(QStringLiteral("ayahs")).toArray();
    }

    return {};
}

void QuranBackend::mergeEdition(const QString &editionName, int surahNumber, const QString &fieldName)
{
    const QJsonArray ayahs = ayahsForEdition(editionName, surahNumber);
    if (ayahs.isEmpty()) {
        qWarning() << "QuranBackend missing edition/surah:" << editionName << surahNumber;
        return;
    }

    if (m_verses.isEmpty())
        m_verses.resize(ayahs.size());

    for (const QJsonValue &ayahValue : ayahs) {
        const QJsonObject ayah = ayahValue.toObject();
        const int index = ayah.value(QStringLiteral("numberInSurah")).toInt() - 1;
        if (index < 0 || index >= m_verses.size())
            continue;

        QVariantMap verse = m_verses.at(index).toMap();
        verse.insert(QStringLiteral("num"), index + 1);
        verse.insert(QStringLiteral("source"), QStringLiteral("Bundled quran.json"));
        verse.insert(fieldName, ayah.value(QStringLiteral("text")).toString());
        verse.insert(QStringLiteral("translit"), verse.value(QStringLiteral("translit")).toString());
        m_verses[index] = verse;
    }
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
