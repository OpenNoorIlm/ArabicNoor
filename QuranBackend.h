#pragma once
#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QString>

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
    Q_INVOKABLE QVariantMap resolveReference(const QString &referenceType, int value);
    Q_INVOKABLE int referenceMaximum(const QString &referenceType) const;

signals:
    void versesChanged();
    void loadingChanged();
    void errorChanged();

private:
    bool ensureDatabase();
    QString databasePath();
    void setLoading(bool loading);
    void setError(const QString &error);

    QVariantList m_verses;
    QString m_connectionName;
    int m_loadedSurah = 0;
    bool m_loading = false;
    QString m_error;
};
