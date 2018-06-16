#ifndef APPLICATION_H
#define APPLICATION_H

#include <QObject>
#include <QQuickItem>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QString>
#include <QQuickView>
#include <QAbstractListModel>

#include "searchenginehelper.h"

class Application : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString searchText READ getSearchText WRITE setSearchText NOTIFY searchTextChanged)
	Q_PROPERTY(QAbstractListModel * suggestionModel READ getSuggestionModel NOTIFY suggestionModelChanged)
	Q_PROPERTY(QString searchingURL READ getSearchingUrl WRITE setSearchingUrl NOTIFY searchingURLChanged)
	Q_PROPERTY(bool fullScreenOn READ getFullScreenOn WRITE setFullScreenOn NOTIFY fullScreenOnChanged)
	Q_PROPERTY(bool reloadWebPage READ getReloadWebPage WRITE setReloadWebPage NOTIFY reloadWebPageChanged)
public:
	explicit Application(QObject *parent = nullptr);
	~Application();
	Q_INVOKABLE void searchEngineTextChanged(QString textChanged);
	Q_INVOKABLE QUrl fromUserInput(const QString& userInput);
	void setSearchText(const QString &searchEngineText);
	SearchSuggestion *getSuggestionModel() const;
	QString getSearchText() const;
	QString getSearchingUrl() const;
	void setSearchingUrl(const QString &url);
	bool getFullScreenOn() const;
	void setFullScreenOn(bool fullScreenOn);
	bool getReloadWebPage() const;
	void setReloadWebPage(bool reloadWebPage);

signals:
	void searchTextChanged();
	void suggestionModelChanged();
	void searchingURLChanged();
	void fullScreenOnChanged();
	void reloadWebPageChanged();

public slots:
private:
	bool loadQml( const QString &fileToLoad );
    QQmlApplicationEngine               m_QMLLoader;
	QQmlContext                        *m_CurrentContext;
	SearchEngineHelper                 *m_SearchEngineHelper;
	QString                             m_SearchText;
	bool                                m_FullScreenOn;
	bool                                m_ReloadWebPage;
};

#endif // APPLICATION_H
