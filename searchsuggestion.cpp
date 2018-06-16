#include "searchsuggestion.h"

SearchSuggestion::SearchSuggestion(QObject *parent)
	: QAbstractListModel(parent)
	, m_SearhcSuggestions()
{
}

int SearchSuggestion::rowCount(const QModelIndex &parent) const
{
	if (parent.isValid())
		return 0;
	return m_SearhcSuggestions.count();
}

QVariant SearchSuggestion::data(const QModelIndex &index, int role) const
{
	if (!index.isValid())
		return QVariant();
	switch (role)
	{
	case Suggestion:
		return m_SearhcSuggestions.at(index.row());
	case Count:
		return m_SearhcSuggestions.count();
	default:
		return QVariant();
	}

}

QHash<int, QByteArray> SearchSuggestion::roleNames() const
{
	QHash<int,QByteArray> roles;
	roles[Suggestion]="suggestion";
	roles[Count]="count";
	return roles;
}

void SearchSuggestion::clearSuggestions()
{
	beginResetModel();
	m_SearhcSuggestions.clear();
	endResetModel();
}

void SearchSuggestion::addSuggestions(const QString &suggestion)
{
	beginResetModel();
	m_SearhcSuggestions.append(suggestion);
	endResetModel();
}
