#pragma once
#include <QObject>
#include <QVariantList>
#include <QNetworkAccessManager>
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
    void versesChanged(); void loadingChanged(); void errorChanged();
private:
    QNetworkAccessManager m_network; QVariantList m_verses; bool m_loading = false; QString m_error;
};
