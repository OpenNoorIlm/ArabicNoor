#include "QuranBackend.h"
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
QuranBackend::QuranBackend(QObject *p):QObject(p){}
void QuranBackend::loadSurah(int number){ m_loading=true; emit loadingChanged(); auto *r=m_network.get(QNetworkRequest(QUrl(QString("https://api.alquran.cloud/v1/surah/%1/quran-uthmani").arg(number)))); connect(r,&QNetworkReply::finished,this,[this,r]{ m_loading=false; emit loadingChanged(); const auto d=QJsonDocument::fromJson(r->readAll()); r->deleteLater(); m_verses.clear(); for(const auto &a:d["data"].toObject()["ayahs"].toArray()){const auto o=a.toObject(); QVariantMap v; v["num"]=o["numberInSurah"].toInt(); v["arabic"]=o["text"].toString(); v["kanzul"]="";v["irfan"]="";v["jalayn"]="";v["translit"]="";m_verses.append(v);} emit versesChanged(); }); }
