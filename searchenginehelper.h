#ifndef SEARCHENGINEHELPER_H
#define SEARCHENGINEHELPER_H

#include <QObject>
#include <QtNetwork>
#include <QtCore>
#include "searchsuggestion.h"

class SearchEngineHelper : public QObject
{
	Q_OBJECT
public:
	Q_PROPERTY(QString searchingURL READ getSearchingUrl NOTIFY searchingURLChanged)

	explicit SearchEngineHelper(QObject *parent = nullptr);
	~SearchEngineHelper();
	void showCompletion(const QVector<QString> &choices);
	SearchSuggestion *getSearchSuggestions() const;
	QString getSearchingUrl() const;
	void setSearchingUrl(const QString &SearchingUrl);

signals:
	void searchSuggestionsChanged();
	void searchingURLChanged();

public slots:
	void doneCompletion();
	void preventSuggest();
	void autoSuggest(const QString &searchText);
	void handleNetworkData(QNetworkReply *networkReply);
	void restartSearchTimer();

private:
	QNetworkAccessManager        m_NetworkManager;
	SearchSuggestion            *m_SearchSuggestions;
	QString                      m_SearchingUrl;
};

#endif // SEARCHENGINEHELPER_H
