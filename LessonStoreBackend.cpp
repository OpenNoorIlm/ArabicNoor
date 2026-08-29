#include "LessonStoreBackend.h"

#include <QDebug>
#include <QTimer>

namespace {

constexpr auto kConfigUrl =
    "https://raw.githubusercontent.com/OpenNoorIlm/NoorArabic-DownloadStore/main/config.yml";

QString subjectTitle(const QString &subject)
{
    const QString normalized = subject.trimmed().toLower();

    if (normalized == QStringLiteral("arabic"))
        return QStringLiteral("Arabic");
    if (normalized == QStringLiteral("nahw"))
        return QStringLiteral("Nahw");
    if (normalized == QStringLiteral("sarf"))
        return QStringLiteral("Sarf");

    return subject;
}

} // namespace

LessonStoreBackend::LessonStoreBackend(QObject *parent)
    : QObject(parent)
    , m_status(tr("Lesson store API pending. Dummy data is loaded."))
{
}

QString LessonStoreBackend::configUrl() const
{
    return QString::fromLatin1(kConfigUrl);
}

QString LessonStoreBackend::status() const
{
    return m_status;
}

bool LessonStoreBackend::loading() const
{
    return m_loading;
}

QVariantList LessonStoreBackend::partsForSubject(const QString &subject) const
{
    const QString normalized = subject.trimmed().toLower();

    if (normalized == QStringLiteral("arabic"))
        return buildParts(subject, 4);
    if (normalized == QStringLiteral("nahw"))
        return buildParts(subject, 3);
    if (normalized == QStringLiteral("sarf"))
        return buildParts(subject, 3);

    return buildParts(subject, 1);
}

QVariantList LessonStoreBackend::lessonsForPart(const QString &subject, int partNumber) const
{
    Q_UNUSED(subject)

    if (partNumber <= 0)
        return {};

    return buildLessons(subject, partNumber, 5);
}

QString LessonStoreBackend::napfStatus(const QString &subject, int partNumber, int lessonNumber) const
{
    Q_UNUSED(subject)
    Q_UNUSED(partNumber)
    Q_UNUSED(lessonNumber)

    return tr("Not downloaded");
}

void LessonStoreBackend::refreshConfig()
{
    qDebug() << "LessonStoreBackend::refreshConfig dummy call" << configUrl();
    setLoading(true);
    setStatus(tr("Config download/parsing API pending. Showing dummy lesson index."));

    QTimer::singleShot(250, this, [this] {
        setLoading(false);
        setStatus(tr("Dummy lesson index ready. Real YAML + NAPF support pending."));
    });
}

void LessonStoreBackend::downloadNapf(const QString &subject, int partNumber, int lessonNumber, const QString &kind)
{
    qDebug() << "LessonStoreBackend::downloadNapf dummy call"
             << subject << partNumber << lessonNumber << kind;

    setStatus(tr("NAPF download API pending: %1 Part %2 Lesson %3 %4")
                  .arg(subjectTitle(subject))
                  .arg(partNumber)
                  .arg(lessonNumber)
                  .arg(kind));

    emit napfDownloadRequested(subject, partNumber, lessonNumber, kind);
}

QString LessonStoreBackend::resolveAsset(const QString &relativePath) const
{
    return relativePath;
}

QVariantList LessonStoreBackend::buildParts(const QString &subject, int count) const
{
    QVariantList parts;
    parts.reserve(count);

    for (int index = 1; index <= count; ++index) {
        QVariantMap part;
        part.insert(QStringLiteral("number"), index);
        part.insert(QStringLiteral("name"), tr("Part %1").arg(index));
        part.insert(QStringLiteral("title"), tr("%1 Part %2").arg(subjectTitle(subject)).arg(index));
        part.insert(QStringLiteral("available"), true);
        parts.append(part);
    }

    return parts;
}

QVariantList LessonStoreBackend::buildLessons(const QString &subject, int partNumber, int count) const
{
    QVariantList lessons;
    lessons.reserve(count);

    for (int index = 1; index <= count; ++index) {
        QVariantMap lesson;
        lesson.insert(QStringLiteral("number"), index);
        lesson.insert(QStringLiteral("title"),
                      tr("%1 Lesson %2").arg(subjectTitle(subject)).arg(index));
        lesson.insert(QStringLiteral("lessonPath"),
                      tr("./part%1/lesson%2/lesson.napf").arg(partNumber).arg(index));
        lesson.insert(QStringLiteral("testPath"),
                      tr("./part%1/lesson%2/test.napf").arg(partNumber).arg(index));
        lesson.insert(QStringLiteral("status"), napfStatus(subject, partNumber, index));
        lessons.append(lesson);
    }

    return lessons;
}

void LessonStoreBackend::setStatus(const QString &status)
{
    if (m_status == status)
        return;

    m_status = status;
    emit statusChanged();
}

void LessonStoreBackend::setLoading(bool loading)
{
    if (m_loading == loading)
        return;

    m_loading = loading;
    emit loadingChanged();
}
