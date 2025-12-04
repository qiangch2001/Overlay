import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    opacity: 0.6
    width: Screen.width
    height: Screen.height
    // visible: true
    color: "black"
    flags: Qt.Tool | Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            console.log("Brightness", Brightness.readScreenLuminance())
        }
    }
}
