import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: root

    property bool active: false
    property var selectedItem
    property var games: []

    property var items: []
    property var enabledItems: []
    property var itemIndexes: []

    signal indexChanged(int index)

    function emitIndexChanged() {
        const index = itemIndexes[listView.currentIndex];

        if (index != null) {
            root.indexChanged(index);
        }
    }

    function isLetter(c) {
        return c.toLocaleUpperCase() != c.toLocaleLowerCase() || c.codePointAt(0) > 127;
    }

    function getInitial(title) {
        if (!title || title.length === 0) {
            return '#';
        }

        const initial = title.charAt(0).toUpperCase();
        return isLetter(initial) ? initial : '#';
    }

    function updateNavigation() {
        const tempItems = ['#', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

        const tempEnabledItems = new Array(tempItems.length).fill(false);
        const tempItemIndexes = new Array(tempItems.length).fill(null);

        let previousInitial = '';

        for (let i = 0; i < games.count; i++) {
            const game = games.get(i);
            const initial = getInitial(game && game.title ? String(game.title) : '');

            if (initial !== previousInitial) {
                previousInitial = initial;

                const charIndex = tempItems.indexOf(initial);

                if (charIndex !== -1) {
                    tempItemIndexes[charIndex] = i;
                    tempEnabledItems[charIndex] = true;
                }
            }
        }

        items = tempItems;
        enabledItems = tempEnabledItems;
        itemIndexes = tempItemIndexes;

        updateCurrentIndex();
    }

    function updateCurrentIndex() {
        const initial = selectedItem && selectedItem.title ? getInitial(String(selectedItem.title)) : '#';

        const navigationBarIndex = items.indexOf(initial);

        if (navigationBarIndex !== -1) {
            listView.currentIndex = navigationBarIndex;
        } else {
            listView.currentIndex = 0;
        }
    }

    function prev() {
        sfxNav.play();

        const startingIndex = listView.currentIndex;

        do {
            const previousIndex = listView.currentIndex;
            listView.decrementCurrentIndex();

            if (previousIndex === listView.currentIndex) {
                listView.currentIndex = startingIndex;
                break;
            }
        } while (!listView.currentItem.enabled)

        emitIndexChanged();
    }

    function next() {
        sfxNav.play();

        const startingIndex = listView.currentIndex;

        do {
            const previousIndex = listView.currentIndex;
            listView.incrementCurrentIndex();

            if (previousIndex === listView.currentIndex) {
                listView.currentIndex = startingIndex;
                break;
            }
        } while (!listView.currentItem.enabled)

        emitIndexChanged();
    }

    onActiveChanged: {
        Qt.callLater(updateCurrentIndex);
    }

    onGamesChanged: {
        Qt.callLater(updateNavigation);
    }

    onSelectedItemChanged: {
        Qt.callLater(updateCurrentIndex);
    }

    Keys.onUpPressed: {
        event.accepted = true;
        prev();
    }

    Keys.onDownPressed: {
        event.accepted = true;
        next();
    }

    ListView {
        id: listView

        width: parent.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        model: root.items.length

        delegate: Item {
            property bool selected: ListView.isCurrentItem

            enabled: !!root.enabledItems[index]

            opacity: enabled ? (selected && !root.activeFocus ? 0.8 : 1) : 0.33

            width: parent ? parent.width : height
            height: vpx(32) * uiScale

            Rectangle {
                id: background

                anchors.fill: parent

                color: (selected && root.activeFocus) ? api.memory.get('settings.general.accentColor') : 'transparent'

                border.width: (selected && !root.activeFocus) ? vpx(2) : 0
                border.color: api.memory.get('settings.general.accentColor')
                radius: vpx(5)

                layer.enabled: selected
                layer.effect: DropShadowLow {}

                scale: selected ? (root.activeFocus ? 1 : 0.98) : 0

                Behavior on scale {
                    NumberAnimation {
                        duration: 333
                        from: 0
                        easing.type: Easing.OutBack
                    }
                }

                visible: selected
            }

            Text {
                text: root.items[index]

                font.family: subtitleFont.name
                font.pixelSize: parent.height * 0.4
                font.bold: true

                anchors.fill: parent

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                opacity: selected ? 1 : 0.5

                color: (selected && root.activeFocus) ? api.memory.get('settings.general.backgroundColor') : api.memory.get('settings.general.textColor')

                layer.enabled: !selected
                layer.effect: DropShadowLow {}
            }
        }

        spacing: vpx(5)

        currentIndex: 0
        orientation: ListView.Vertical

        snapMode: ListView.SnapOneItem
        highlightMoveDuration: 0
    }
}
