import QtQuick 2.15

FocusScope {
    id: root

    readonly property alias list: gameLibrary
    readonly property var currentGame: gameLibrary.currentItem ? gameLibrary.currentItem.currentGame : undefined

    property int currentIndex: 0

    GameLibrary {
        id: gameLibrary

        anchors.fill: parent
        focus: root.focus

        model: gameLibraryModel.games

        currentIndex: root.currentIndex
        onCurrentIndexChanged: root.currentIndex = currentIndex
    }

    function nextLetter() {
        listView.currentIndex = listView.count - 1;

        var gameLibraryDelegate = listView.itemAtIndex(listView.currentIndex);
        gameLibraryDelegate.nextLetter();
    }
    function prevLetter() {
        listView.currentIndex = listView.count - 1;

        var gameLibraryDelegate = listView.itemAtIndex(listView.currentIndex);
        gameLibraryDelegate.prevLetter();
    }
}
