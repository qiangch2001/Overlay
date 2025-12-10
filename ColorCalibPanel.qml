import QtQuick 2.15

Item {
    id: root
    width: 150
    height: parent.height

    property color baseColor: "red"
    property string label: "Red"
    property real alpha: 0.5

    // background
    Rectangle {
        anchors.fill: parent
        color: baseColor
    }

    // black overlay
    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: root.alpha
    }

    // title
    Text {
        text: root.label
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 12
        color: "white"
        font.pointSize: 16
        font.bold: true
    }

    // slider
    Item {
        id: slider
        width: 40
        height: parent.height * 0.65
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            anchors.fill: parent
            radius: 6
            color: "#333"
        }

        Rectangle {
            id: handle
            width: parent.width
            height: 22
            radius: 6
            y: root.alpha * (parent.height - height)
            color: "#ff7a3c"
        }

        MouseArea {
            anchors.fill: parent
            onPressed: update(mouse.y)
            onPositionChanged: if (pressed) update(mouse.y)

            function update(py) {
                let y = Math.max(0, Math.min(py, height - handle.height))
                root.alpha = y / (height - handle.height)
            }
        }
    }

    // Show number
    Text {
        text: "Alpha: " + root.alpha.toFixed(2)
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 12
        color: "white"
        font.pixelSize: 14
    }
}
