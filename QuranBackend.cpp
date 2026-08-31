#include "QuranBackend.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QStandardPaths>

QuranBackend::QuranBackend(QObject *parent)
    : QObject(parent)
{
    m_connectionName = QStringLiteral("NoorArabicQuran_%1")
                           .arg(reinterpret_cast<quintptr>(this));
}

void QuranBackend::loadSurah(int number)
{
    qDebug() << "QuranBackend::loadSurah called with surah" << number;

    if (number < 1 || number > 114) {
        setError(tr("Surah number must be between 1 and 114."));
        return;
    }

    if (number == m_loadedSurah && !m_verses.isEmpty()) {
        emit versesChanged();
        return;
    }

    setError(QString());
    setLoading(true);
    m_verses.clear();
    emit versesChanged();

    if (!ensureDatabase()) {
        setLoading(false);
        return;
    }

    QSqlDatabase db = QSqlDatabase::database(m_connectionName);
    QSqlQuery query(db);
    query.prepare(QStringLiteral(
        "SELECT ayah, text_uthmani, text_kanzuliman, text_jalalayn, text_sahih, "
        "id, juz, page, manzil, ruku, hizb_quarter "
        "FROM verses "
        "WHERE surah = :surah "
        "ORDER BY ayah"));
    query.bindValue(QStringLiteral(":surah"), number);

    if (!query.exec()) {
        setError(tr("Could not query bundled quran.db."));
        qWarning() << "QuranBackend query failed:" << query.lastError().text();
        setLoading(false);
        return;
    }

    QVariantList nextVerses;
    while (query.next()) {
        QVariantMap verse;
        verse.insert(QStringLiteral("num"), query.value(0).toInt());
        verse.insert(QStringLiteral("arabic"), query.value(1).toString());
        verse.insert(QStringLiteral("kanzul"), query.value(2).toString());
        verse.insert(QStringLiteral("jalayn"), query.value(3).toString());
        verse.insert(QStringLiteral("sahih"), query.value(4).toString());
        verse.insert(QStringLiteral("globalAyah"), query.value(5).toInt());
        verse.insert(QStringLiteral("juz"), query.value(6).toInt());
        verse.insert(QStringLiteral("page"), query.value(7).toInt());
        verse.insert(QStringLiteral("manzil"), query.value(8).toInt());
        verse.insert(QStringLiteral("ruku"), query.value(9).toInt());
        verse.insert(QStringLiteral("hizbQuarter"), query.value(10).toInt());
        verse.insert(QStringLiteral("irfan"), tr("Kanzul Irfan is not present in bundled quran.db."));
        verse.insert(QStringLiteral("translit"), QString());
        verse.insert(QStringLiteral("source"), QStringLiteral("Bundled quran.db"));
        nextVerses.append(verse);
    }

    m_verses = nextVerses;
    m_loadedSurah = number;

    if (m_verses.isEmpty())
        setError(tr("No verses found for this surah in bundled quran.db."));

    setLoading(false);
    emit versesChanged();
    qDebug() << "QuranBackend loaded DB verses:" << m_verses.size();
}

QVariantMap QuranBackend::resolveReference(const QString &referenceType, int value, int currentSurah)
{
    QVariantMap result;
    result.insert(QStringLiteral("ok"), false);
    result.insert(QStringLiteral("surah"), 0);
    result.insert(QStringLiteral("ayah"), 0);

    const QString type = referenceType.trimmed().toLower();
    const int maximum = type == QStringLiteral("surahayah")
                            ? surahAyahMaximum(currentSurah)
                            : referenceMaximum(type);
    if (maximum <= 0) {
        result.insert(QStringLiteral("error"), tr("Unknown Quran reference type."));
        return result;
    }

    if (value < 1 || value > maximum) {
        result.insert(QStringLiteral("error"), tr("Enter a value from 1 to %1.").arg(maximum));
        return result;
    }

    if (!ensureDatabase())
        return result;

    QString column;
    QString label;

    if (type == QStringLiteral("surahayah")) {
        QSqlDatabase db = QSqlDatabase::database(m_connectionName);
        QSqlQuery query(db);
        query.prepare(QStringLiteral(
            "SELECT surah, ayah "
            "FROM verses "
            "WHERE surah = :surah AND ayah = :ayah "
            "LIMIT 1"));
        query.bindValue(QStringLiteral(":surah"), currentSurah);
        query.bindValue(QStringLiteral(":ayah"), value);

        if (!query.exec() || !query.next()) {
            result.insert(QStringLiteral("error"), tr("Could not find that ayah in this surah."));
            qWarning() << "QuranBackend surah ayah lookup failed:"
                       << currentSurah << value << query.lastError().text();
            return result;
        }

        result.insert(QStringLiteral("ok"), true);
        result.insert(QStringLiteral("surah"), query.value(0).toInt());
        result.insert(QStringLiteral("ayah"), query.value(1).toInt());
        result.insert(QStringLiteral("label"), tr("Go to Surah %1, Ayah %2")
                      .arg(query.value(0).toInt())
                      .arg(query.value(1).toInt()));
        return result;
    } else if (type == QStringLiteral("ayah")) {
        column = QStringLiteral("id");
        label = tr("Quran ayah");
    } else if (type == QStringLiteral("juz")) {
        column = QStringLiteral("juz");
        label = tr("juz");
    } else if (type == QStringLiteral("page")) {
        column = QStringLiteral("page");
        label = tr("page");
    } else if (type == QStringLiteral("manzil")) {
        column = QStringLiteral("manzil");
        label = tr("manzil");
    } else if (type == QStringLiteral("ruku")) {
        column = QStringLiteral("ruku");
        label = tr("ruku");
    } else if (type == QStringLiteral("hizbquarter")) {
        column = QStringLiteral("hizb_quarter");
        label = tr("hizb quarter");
    }

    QSqlDatabase db = QSqlDatabase::database(m_connectionName);
    QSqlQuery query(db);
    query.prepare(QStringLiteral(
        "SELECT surah, ayah "
        "FROM verses "
        "WHERE %1 = :value "
        "ORDER BY id "
        "LIMIT 1").arg(column));
    query.bindValue(QStringLiteral(":value"), value);

    if (!query.exec() || !query.next()) {
        result.insert(QStringLiteral("error"), tr("Could not find that Quran reference."));
        qWarning() << "QuranBackend reference lookup failed:" << type << value << query.lastError().text();
        return result;
    }

    const int surah = query.value(0).toInt();
    const int ayah = query.value(1).toInt();

    result.insert(QStringLiteral("ok"), true);
    result.insert(QStringLiteral("surah"), surah);
    result.insert(QStringLiteral("ayah"), ayah);
    result.insert(QStringLiteral("label"), tr("Go to %1 %2: Surah %3, Ayah %4")
                  .arg(label)
                  .arg(value)
                  .arg(surah)
                  .arg(ayah));
    return result;
}

int QuranBackend::surahAyahMaximum(int surahNumber)
{
    if (surahNumber < 1 || surahNumber > 114)
        return 0;

    if (!ensureDatabase())
        return 0;

    QSqlDatabase db = QSqlDatabase::database(m_connectionName);
    QSqlQuery query(db);
    query.prepare(QStringLiteral(
        "SELECT MAX(ayah) "
        "FROM verses "
        "WHERE surah = :surah"));
    query.bindValue(QStringLiteral(":surah"), surahNumber);

    if (!query.exec() || !query.next()) {
        qWarning() << "QuranBackend surah max lookup failed:" << query.lastError().text();
        return 0;
    }

    return query.value(0).toInt();
}

int QuranBackend::referenceMaximum(const QString &referenceType) const
{
    const QString type = referenceType.trimmed().toLower();

    if (type == QStringLiteral("ayah"))
        return 6236;
    if (type == QStringLiteral("juz"))
        return 30;
    if (type == QStringLiteral("page"))
        return 604;
    if (type == QStringLiteral("manzil"))
        return 7;
    if (type == QStringLiteral("ruku"))
        return 556;
    if (type == QStringLiteral("hizbquarter"))
        return 240;

    return 0;
}

bool QuranBackend::ensureDatabase()
{
    if (QSqlDatabase::contains(m_connectionName) && QSqlDatabase::database(m_connectionName).isOpen())
        return true;

    const QString targetPath = databasePath();
    if (targetPath.isEmpty())
        return false;

    QFile resourceFile(QStringLiteral(":/qt/qml/NoorArabic/data/quran.db"));
    if (!resourceFile.open(QIODevice::ReadOnly)) {
        resourceFile.setFileName(QStringLiteral(":/data/quran.db"));
        if (!resourceFile.open(QIODevice::ReadOnly)) {
            setError(tr("Could not open bundled quran.db."));
            qWarning() << "QuranBackend could not open quran.db resource";
            return false;
        }
    }

    const QFileInfo targetInfo(targetPath);
    const bool needsCopy = !targetInfo.exists() || targetInfo.size() != resourceFile.size();

    if (needsCopy) {
        QDir().mkpath(targetInfo.absolutePath());

        QFile outputFile(targetPath);
        if (!outputFile.open(QIODevice::WriteOnly)) {
            setError(tr("Could not prepare local quran.db copy."));
            qWarning() << "QuranBackend could not write quran.db copy:" << outputFile.errorString();
            return false;
        }

        outputFile.write(resourceFile.readAll());
        outputFile.close();
    }

    QSqlDatabase db = QSqlDatabase::addDatabase(QStringLiteral("QSQLITE"), m_connectionName);
    db.setDatabaseName(targetPath);
    if (!db.open()) {
        setError(tr("Could not open local quran.db."));
        qWarning() << "QuranBackend could not open quran.db:" << db.lastError().text();
        return false;
    }

    qDebug() << "QuranBackend opened SQLite DB:" << targetPath;
    return true;
}

QString QuranBackend::databasePath()
{
    QString basePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    if (basePath.isEmpty())
        basePath = QStandardPaths::writableLocation(QStandardPaths::CacheLocation);

    if (basePath.isEmpty()) {
        setError(tr("No writable app data location for quran.db."));
        return {};
    }

    return QDir(basePath).filePath(QStringLiteral("quran.db"));
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
