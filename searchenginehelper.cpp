#include "searchenginehelper.h"

const QString GOOGLE_SUGGESTION_SEARCH_URL(QStringLiteral("http://google.com/complete/search?output=toolbar&q=%1"));
const QString GOOGLE_SEARCH_URL(QStringLiteral("https://www.google.com/search?q=facebook"));

SearchEngineHelper::SearchEngineHelper(QObject *parent)
	: QObject(parent)
	, m_NetworkManager()
//	, m_SearchSuggestions( new SearchSuggestion(this) )
	, m_SearchingUrl()
{
	connect(&m_NetworkManager, SIGNAL(finished(QNetworkReply*)),
			this, SLOT(handleNetworkData(QNetworkReply*)));

}

SearchEngineHelper::~SearchEngineHelper()
{
}

void SearchEngineHelper::showCompletion(const QVector<QString> &choices)
{
	if (choices.isEmpty())
		return;

//	m_SearchSuggestions->clearSuggestions();
//	for (const auto &choice : choices)
//		m_SearchSuggestions->addSuggestions(choice);
//	emit searchSuggestionsChanged();
}

void SearchEngineHelper::doneCompletion()
{
}

void SearchEngineHelper::preventSuggest()
{
}

void SearchEngineHelper::autoSuggest( const QString & searchText )
{
	m_SearchingUrl = GOOGLE_SEARCH_URL+ searchText;
	m_NetworkManager.get(QNetworkRequest(GOOGLE_SUGGESTION_SEARCH_URL.arg(searchText)));
}

void SearchEngineHelper::handleNetworkData(QNetworkReply *networkReply)
{
	QUrl url = networkReply->url();
	if (networkReply->error() == QNetworkReply::NoError) {
		QVector<QString> choices;

		QByteArray response(networkReply->readAll());
		QXmlStreamReader xml(response);
		while (!xml.atEnd()) {
			xml.readNext();
			if (xml.tokenType() == QXmlStreamReader::StartElement)
				if (xml.name() == "suggestion") {
					QStringRef str = xml.attributes().value("data");
					choices << str.toString();
				}
		}

		showCompletion(choices);
	}

	networkReply->deleteLater();
}

void SearchEngineHelper::restartSearchTimer()
{

}

QString SearchEngineHelper::getSearchingUrl() const
{
	return m_SearchingUrl;
}

void SearchEngineHelper::setSearchingUrl(const QString &SearchingUrl)
{
	if( m_SearchingUrl != SearchingUrl )
	{
		m_SearchingUrl = SearchingUrl;
		emit searchingURLChanged();
	}
}

SearchSuggestion* SearchEngineHelper::getSearchSuggestions() const
{
	return m_SearchSuggestions;
}
