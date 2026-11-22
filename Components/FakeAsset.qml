import QtQuick 2.3
import QtMultimedia 5.9

Image {
    property var games
    readonly property string assetKey: settingsMetadata.library.art.values[api.memory.get('settings.library.art')]

    source: {
        if (games != null) {
            for (let i = 0; i < games.count; i++) {
                let game = games.get(i);
                if (game && game.assets && game.assets[assetKey]) {
                    return game.assets[assetKey];
                }
            }
        }

        return '';
    }

    fillMode: Image.PreserveAspectFit

    asynchronous: !api.memory.get('settings.library.aspectRatioNative')
    visible: false
    enabled: false
}
