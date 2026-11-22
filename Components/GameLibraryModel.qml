import QtQuick 2.3
import SortFilterProxyModel 0.2

Item {
    anchors.fill: parent

    readonly property alias games: games

    ValueFilter {
        id: bookmarkFilter
        roleName: 'favorite'
        value: true
        enabled: filterByBookmarks
    }

    RoleSorter {
        id: titleSorter
        roleName: 'title'
        sortOrder: Qt.AscendingOrder
    }

    SortFilterProxyModel {
        id: games

        sourceModel: api.allGames

        filters: bookmarkFilter
        sorters: [titleSorter]

        delayed: true
    }
}
