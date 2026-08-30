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
        "SELECT ayah, text_uthmani, text_kanzuliman, text_jalalayn, text_sahih "
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
