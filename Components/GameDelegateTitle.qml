import QtQuick 2.15

Column {
    id: root

    property var game
    property bool selected

    readonly property bool titleEnabled: api.memory.get('settings.cardTheme.titleEnabled')
    readonly property bool titleAlwaysVisible: api.memory.get('settings.cardTheme.titleAlwaysVisible')
    readonly property real titleFontSize: vpx(gameDelegateTitleFontSize)

    readonly property bool borderEnabled: api.memory.get('settings.cardTheme.borderEnabled')
    readonly property real borderWidth: api.memory.get('settings.cardTheme.borderWidth')

    opacity: selected ? 1 : 0.2
    visible: titleEnabled && (titleAlwaysVisible || selected)

    topPadding: gameDelegateTitlePadding + (borderEnabled ? borderWidth : 0)
    bottomPadding: gameDelegateTitlePadding

    spacing: gameDelegateTitlePadding * 0.25

    Marquee {
        id: titleScroller

        width: parent.width
        height: titleFontSize

        text: game ? game.title : ''
        selected: root.selected
    }

    Row {
        width: childrenRect.width
        height: titleFontSize

        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: releaseYear

            color: textColor

            text: game ? game.releaseYear : ''
            width: Math.min(releaseYearMetrics.width, root.width)
            height: parent.height

            anchors.verticalCenter: parent.verticalCenter

            font.family: subtitleFont.name
            font.pixelSize: titleFontSize
            fontSizeMode: Text.VerticalFit

            elide: releaseYearMetrics.width > root.width ? Text.ElideRight : Text.ElideNone

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            style: Text.Outline

            TextMetrics {
                id: releaseYearMetrics

                text: releaseYear.text

                font.family: subtitleFont.name
                font.pixelSize: releaseYear.font.pixelSize
            }
        }
    }
}
