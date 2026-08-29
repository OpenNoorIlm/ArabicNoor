#pragma once

#include <QObject>
#include <QVariantList>

class LessonStoreBackend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString configUrl READ configUrl CONSTANT)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)

public:
    explicit LessonStoreBackend(QObject *parent = nullptr);

    QString configUrl() const;
    QString status() const;
    bool loading() const;

    Q_INVOKABLE QVariantList partsForSubject(const QString &subject) const;
    Q_INVOKABLE QVariantList lessonsForPart(const QString &subject, int partNumber) const;
    Q_INVOKABLE QString napfStatus(const QString &subject, int partNumber, int lessonNumber) const;
    Q_INVOKABLE void refreshConfig();
    Q_INVOKABLE void downloadNapf(const QString &subject, int partNumber, int lessonNumber, const QString &kind);
    Q_INVOKABLE QString resolveAsset(const QString &relativePath) const;

signals:
    void statusChanged();
    void loadingChanged();
    void napfDownloadRequested(const QString &subject, int partNumber, int lessonNumber, const QString &kind);

private:
    QVariantList buildParts(const QString &subject, int count) const;
    QVariantList buildLessons(const QString &subject, int partNumber, int count) const;
    void setStatus(const QString &status);
    void setLoading(bool loading);

    QString m_status;
    bool m_loading = false;
};
