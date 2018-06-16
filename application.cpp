#include "application.h"
#include <QDebug>
#include <QQmlContext>

Application::Application(QObject *parent)
	: QObject(parent)
	, m_QMLLoader()
    , m_CurrentContext(nullptr)
    , m_SearchEngineHelper( new SearchEngineHelper(this) )
	, m_SearchText()
	, m_FullScreenOn(false)
	, m_ReloadWebPage(false)
{
	loadQml("qrc:/main.qml") ? qDebug() << "Error in loading the qml file"
							 : qDebug() << "Main.qml loaded";
	connect(m_SearchEngineHelper, &SearchEngineHelper::searchSuggestionsChanged, this, &Application::suggestionModelChanged);
	connect( m_SearchEngineHelper, &SearchEngineHelper::searchingURLChanged, this, &Application::searchingURLChanged);
}

Application::~Application()
{
}

void Application::searchEngineTextChanged( QString textChanged )
{
	setSearchText(textChanged);
	m_SearchEngineHelper->autoSuggest( m_SearchText );
}

void Application::setSearchText(const QString &searchEngineText)
{
	if( m_SearchText != searchEngineText )
	{
		m_SearchText = searchEngineText;
		emit searchTextChanged();
	}
}

SearchSuggestion * Application::getSuggestionModel() const
{
	return m_SearchEngineHelper->getSearchSuggestions();
}

bool Application::loadQml(const QString &fileToLoad)
{
	m_QMLLoader.rootContext()->setContextProperty("rootWindow", this);
	m_QMLLoader.rootContext()->setContextProperty("searchHelper", m_SearchEngineHelper);
	m_QMLLoader.load(QUrl(fileToLoad));
	return m_QMLLoader.rootObjects().isEmpty();
}

bool Application::getReloadWebPage() const
{
	return m_ReloadWebPage;
}

void Application::setReloadWebPage(bool reloadWebPage)
{
	if( m_ReloadWebPage != reloadWebPage )
	{
		m_ReloadWebPage = reloadWebPage;
		emit reloadWebPageChanged();
	}
}

bool Application::getFullScreenOn() const
{
	return m_FullScreenOn;
}

void Application::setFullScreenOn(bool fullScreenOn)
{
	if( m_FullScreenOn != fullScreenOn )
	{
		m_FullScreenOn = fullScreenOn;
		emit fullScreenOnChanged();
	}
}

QString Application::getSearchText() const
{
	return m_SearchText;
}

QUrl Application::fromUserInput(const QString& userInput)
{
	QFileInfo fileInfo(userInput);
	if (fileInfo.exists())
		return QUrl::fromLocalFile(fileInfo.absoluteFilePath());
	return QUrl::fromUserInput(userInput);
}

QString Application::getSearchingUrl() const
{
	return m_SearchEngineHelper->getSearchingUrl();
}

void Application::setSearchingUrl( const QString &url )
{
	m_SearchEngineHelper->setSearchingUrl(url);
}
