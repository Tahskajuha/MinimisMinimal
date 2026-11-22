import QtQuick 2.3
import QtQml.Models 2.10

ListView {
    id: root

    height: vpx(33) * ((uiScale ?? 1) < 0 ? 1 : uiScale)

    anchors {
        left: parent.left
        right: parent.right
        top: parent.top

        topMargin: height / 2.0
        bottomMargin: height / 2.0
    }

    spacing: vpx(12)

    orientation: ListView.Horizontal
    layoutDirection: Qt.RightToLeft

    signal dropdownUpdated()

    model: ObjectModel {
        Button {
            id: settingsButton

            icon: '\uf013'

            width: root.height
            height: root.height

            circle: true
            selected: root.focus && ListView.isCurrentItem

            onActivated: {
                toSettingsView()
            }
        }

        Button {
            id: filterButton

            text: filterDropdownModel.get(filterDropdown.checkedIndex).name

            height: parent.height
            circle: false
            selected: root.focus && ListView.isCurrentItem

            onActivated: {
                filterDropdown.toggle()
            }

            ListModel {
                id: filterDropdownModel

                ListElement { name: 'All Games' }
                ListElement { name: 'Bookmarks' }
            }

            Dropdown {
                id: filterDropdown

                focus: parent.selected

                items: filterDropdownModel
                roleName: 'name'

                checkedIndex: filterByBookmarks ? 1 : 0

                onActivated: (idx) => {
                    filterByBookmarks = idx === 1
                    root.dropdownUpdated()
                }
            }
        }
    }

    Keys.onDownPressed: {
        sfxNav.play()
        showcase.focus = true
    }
}
