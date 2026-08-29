#pragma once
#include <QObject>
#include <QVariantList>
#include <QMap>
#include <QJsonDocument>

class QuranBackend : public QObject {
    Q_OBJECT

    Q_PROPERTY(QVariantList verses READ verses NOTIFY versesChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)
    Q_PROPERTY(QString error READ error NOTIFY errorChanged)

public:
    explicit QuranBackend(QObject *parent = nullptr);

    QVariantList verses() const { return m_verses; }
    bool loading() const { return m_loading; }
    QString error() const { return m_error; }

    Q_INVOKABLE void loadSurah(int number);

signals:
    void versesChanged();
    void loadingChanged();
    void errorChanged();

private:
    bool loadData();
    QJsonArray ayahsForEdition(const QString &editionName, int surahNumber) const;
    void mergeEdition(const QString &editionName, int surahNumber, const QString &fieldName);
    void setLoading(bool loading);
    void setError(const QString &error);

    QJsonDocument m_document;
    QVariantList m_verses;
    bool m_dataLoaded = false;
    bool m_loading = false;
    QString m_error;
};
