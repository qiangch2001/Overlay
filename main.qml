import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.folderlistmodel 2.15
import QtQuick.Layouts 1.15

Window {
    width: Screen.width
    height: Screen.height
    color: "black"

    // Day/Night Mode
    property bool nightMode: true
    property color bgColor: nightMode ? "black" : "white"
    property color textColor: nightMode ? "white" : "black"

    // Read Gpoi
    function readGpio() {
        return Gpio.readValue();
    }


    property int lastValue: 0
    property bool pressedFlag: false

    // Change mode
    function pollGpio() {
        var v = readGpio()

        if(v === 0) {
            nightMode = false;    // set to Day mode
        }
        else{
            nightMode = true;     // set to Night mode
        }
    }

    // GPIO Timer
    Timer {
        interval: 100
        repeat: true
        running: true
        onTriggered: pollGpio()
    }

    property string selected_image: ""

    // Show Images
    Image {
        anchors.fill: parent
        source: selected_image
        fillMode: Image.PreserveAspectFit
        z: 0
    }

    // File Explorer
    Rectangle {
        id: menu_panel
        width: parent.width * 0.6
        height: parent.height
        color: bgColor
        anchors.left: parent.left
        z: 10
        visible: false

        Column {
            spacing: 10
            anchors.margins: 20
            anchors.fill: parent

            Text {
                text: "File Explorer"
                anchors.left: parent.left
                anchors.leftMargin: 30
                font.pointSize: 15
                color: textColor
            }

            // File list Module
            Rectangle {
                id: file_window
                width: parent.width
                height: parent.height - 30
                color: bgColor

                // FolderListModel
                FolderListModel {
                    id: folderModel
                    folder: "/root"
                    nameFilters: ["*.png", "*.jpg"]
                }

                Flickable {
                    id: file_explorer
                    anchors.fill: parent
                    contentHeight: fileListContent.height
                    clip: true

                    Column {
                        id: fileListContent
                        width: parent.width

                        Repeater {
                            model: folderModel

                            Rectangle {
                                width: parent.width
                                height: 40
                                color: nightMode ? "#222" : "#ddd"

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    text: fileName
                                    color: textColor
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        selected_image = "file:///" + filePath
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // File Explorer Button
    Rectangle {
        id: menu_button
        width: 30; height: 30; radius: 15
        color: nightMode ? "#80000000" : "#80FFFFFF"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 15
        z: 20

        Text {
            anchors.centerIn: parent
            text: "≡"
            font.pixelSize: 30
            color: textColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                menu_panel.visible = !menu_panel.visible
                setting_panel.visible = false
            }
        }
    }

    // Setting Button
    Rectangle {
        id: setting_button
        width: 30; height: 30; radius: 15
        color: nightMode ? "#80000000" : "#80FFFFFF"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 15
        z: 20

        Image {
            anchors.fill: parent
            source: nightMode ? "res/setting_w.png" : "res/setting_b.png"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                setting_panel.visible = !setting_panel.visible
                menu_panel.visible = false
            }
        }
    }

    // Setting Panel
    Rectangle {
        id: setting_panel
        width: parent.width * 0.6
        height: parent.height
        color: bgColor
        anchors.right: parent.right
        z: 10
        visible: false

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10

            Text {
                text: "Setting"
                anchors.left: parent.left
                font.pointSize: 15
                color: textColor
            }

            // Brightness Slider
            Item {
                id: bsb
                width: 280
                height: 40
                anchors.horizontalCenter: parent.horizontalCenter

                property real value: 80
                property real minValue: 0
                property real maxValue: 100

                Rectangle {
                    anchors.fill: parent
                    radius: 12
                    color: nightMode ? "#202020" : "#dddddd"
                    opacity: 0.95
                }

                Image {
                    source: nightMode? "res/brightness_w.png": "res/brightness_b.png"
                    width: 22; height: 22
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    id: track
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    height: 20

                    Rectangle {
                        id: bg
                        height: 4
                        width: parent.width
                        radius: 2
                        color: nightMode? "#cccccc": "#3a3a3a"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        id: handle
                        width: 14; height: 14; radius: 7
                        color: sliderMouse.pressed ? "#ff9c6b" : "#ff7a3c"
                        y: bg.y + bg.height / 2 - height / 2

                        x: (bsb.value - bsb.minValue) / (bsb.maxValue - bsb.minValue) * (track.width - width)

                        Behavior on x { NumberAnimation { duration: 80 } }
                    }

                    MouseArea {
                        id: sliderMouse
                        anchors.fill: parent
                        hoverEnabled: true

                        onPressed: update(mouse.x)
                        onPositionChanged: if (pressed) update(mouse.x)

                        function update(px) {
                            var w = track.width - handle.width
                            var x = Math.min(w, Math.max(0, px - handle.width / 2))
                            handle.x = x
                            bsb.value =
                                bsb.minValue + (x / w) * (bsb.maxValue - bsb.minValue)
                        }
                    }
                }
            }

            // Change Computing Method
            Rectangle {
                id: brightnessModeSelector
                width: 280
                height: 30
                radius: 4
                color: nightMode ? "#222" : "#ccc"
                border.color: nightMode ? "#444" : "#666"
                anchors.horizontalCenter: parent.horizontalCenter

                property string selectedMode: "Physical"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 5

                    Text {
                        text: brightnessModeSelector.selectedMode
                        color: textColor
                        font.pixelSize: 10
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                    }

                    Text {
                        text: dropdown.visible ? "^" : "v"
                        color: textColor
                        font.pixelSize: 10
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                    }
                }

                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        dropdown.visible = !dropdown.visible
                    }
                }

                Rectangle {
                    id: dropdown
                    width: parent.width
                    color: nightMode ? "#333" : "#eee"
                    radius: 10
                    visible: false
                    y: parent.height + 5

                    Column {
                        width: parent.width
                        spacing: 3
                        padding: 5

                        Repeater {
                            model: [
                                { text: "Physical",         method: 0 },
                                { text: "Top 5%",           method: 1 },
                                { text: "Top 10%",          method: 2 },
                                { text: "Weighted",         method: 3 }
                            ]

                            Rectangle {
                                width: parent.width
                                height: 15
                                radius: 3
                                color: hovered ? (nightMode ? "#444" : "#ddd") : "transparent"

                                property bool hovered: false

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.text
                                    color: textColor
                                    font.pixelSize: 10
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: parent.hovered = true
                                    onExited: parent.hovered = false

                                    onClicked: {
                                        brightnessModeSelector.selectedMode = modelData.text
                                        dropdown.visible = false

                                        Brightness.setAlgorithm(modelData.method)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: personalizeButton
                width: 100
                height: 30
                color: "#323232"
                radius: 6

                anchors.left: parent.left
                anchors.leftMargin: 0

                visible: true
                
                Text {
                    text: "Custom"
                    anchors.centerIn: parent
                    font.pointSize: 12
                    font.bold: true
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        calibPage.visible = true
                    }
                }
            }
        }
    }

    property real overlay_opacity: 0.3

    // Overlay Module
    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "black"
        opacity: overlay_opacity
        z: 900
    }

    Timer {
        interval: 200
        running: true
        repeat: true

        onTriggered: {
            let raw = LightSensor.readAmbientLightValue()
            let alpha = LightSensor.computeAlpha(raw)

            let L_measured = Brightness.readScreenLuminance() * 100
            let L_target   = bsb.value * alpha / 255
            let error      = L_target - L_measured

            let k = 0.005
            overlay_opacity -= k * error

            if (overlay_opacity < 0) overlay_opacity = 0
            if (overlay_opacity > 0.7) overlay_opacity = 0.7
        }
    }

    // Personized Page
    Item {
        id: calibPage
        anchors.fill: parent
        visible: false
        z: 1000

        // Background-color
        Rectangle {
            anchors.fill: parent
            color: "black"
        }

        // Reset button
        Rectangle {
            id: resetBtn
            width: 100
            height: 40
            radius: 6
            anchors.left: parent.left
            anchors.top: parent.top
            color: "#555"

            border.width: 5
            border.color: "black"

            Text {
                anchors.centerIn: parent
                text: "Reset"
                color: "white"
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    redPanel.alpha   = 0.2126
                    greenPanel.alpha = 0.7152
                    bluePanel.alpha  = 0.0722
                }
            }
        }

        // Confirm button
        Rectangle {
            id: confirmBtn
            width: 100
            height: 40
            radius: 6
            anchors.right: parent.right
            anchors.top: parent.top
            color: "#ff7a3c"

            border.width: 5
            border.color: "black"

            Text {
                anchors.centerIn: parent
                text: "Confirm"
                color: "white"
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    let r = redPanel.alpha
                    let g = greenPanel.alpha
                    let b = bluePanel.alpha
                    let s = r + g + b

                    let wR = r / s
                    let wG = g / s
                    let wB = b / s

                    BrtBackend.wR = wR
                    BrtBackend.wG = wG
                    BrtBackend.wB = wB

                    console.log("User RGB Weights:", wR, wG, wB)
                    Brightness.setUserRGBWeights(wR, wG, wB)

                    calibPage.visible = false
                }
            }
        }

        // Title
        Rectangle {
            id: titleCard
            radius: 6
            height: 30

            anchors.left: resetBtn.right
            anchors.right: confirmBtn.left
            anchors.leftMargin: 12
            anchors.rightMargin: 12

            anchors.verticalCenter: resetBtn.verticalCenter

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#ff3b3b" }  // Red
                GradientStop { position: 0.5; color: "#3bff6b" }  // Green
                GradientStop { position: 1.0; color: "#3b6bff" }  // Blue
            }

            Text {
                anchors.centerIn: parent
                text: "RGB Personal Luminance Calibration"
                color: "white"
                font.pointSize: 8
                font.bold: true
                elide: Text.ElideRight
            }
        }

        // RGB area
        Row {
            id: rgbRow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 40
            spacing: 15

            ColorCalibPanel {
                id: redPanel
                baseColor: "red"
                label: "Red"
            }

            ColorCalibPanel {
                id: greenPanel
                baseColor: "green"
                label: "Green"
            }

            ColorCalibPanel {
                id: bluePanel
                baseColor: "blue"
                label: "Blue"
            }
        }
    }
}
