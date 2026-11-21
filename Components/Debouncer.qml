import QtQuick 2.15
import QtQml 2.15

Timer {
    id: root

    property bool enabled: true

    function debounce() {
        enabled ? root.restart() : root.stop();
    }
}
