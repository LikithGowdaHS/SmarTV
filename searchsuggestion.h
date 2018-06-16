#ifndef SEARCHSUGGESTION_H
#define SEARCHSUGGESTION_H

#include <QAbstractListModel>

class SearchSuggestion : public QAbstractListModel
{
	Q_OBJECT

public:

	enum roles
	{
		Suggestion,
		Count
	};
	explicit SearchSuggestion(QObject *parent = nullptr);

	// Basic functionality:
	int rowCount(const QModelIndex &parent = QModelIndex()) const override;
	QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
	void clearSuggestions();
	void addSuggestions(const QString & suggestion);
protected:
	QHash<int,QByteArray>   roleNames() const override;

private:
	QStringList           m_SearhcSuggestions;
};

#endif // SEARCHSUGGESTION_H
