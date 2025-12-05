import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.folderlistmodel 2.15

Window {
    width: Screen.width
    height: Screen.height
    // visible: true
    color: "black"

    property string selected_image: ""

    Image {
        anchors.fill: parent
        source: selected_image
        fillMode: Image.PreserveAspectFit
        z: 0
    }

    Rectangle {
        id: menu_panel
        width: parent.width * 0.6
        height: parent.height
        color: "#d5c8c800"
        anchors.left: parent.left
        z: 10
        visible: false

        Column {
            id: column
            spacing: 10
            anchors.margins: 20
            anchors.fill: parent

            Text {
                text: "File Explorer"
                anchors.left: parent.left
                anchors.leftMargin: 30
                font.pointSize: 15
                color: "white"
            }
            Rectangle {
                id: file_window
                width: parent.width
                height: parent.height - 30
                color: "transparent"

                // FolderListModel（注意：不能用 qrc）
                FolderListModel {
                    id: folderModel
                    folder: "/root"  // 改成真实目录
                    nameFilters: ["*.png", "*.jpg"]
                }

                // 文件列表（可滚动）
                Flickable {
                    id: file_explorer
                    anchors.fill: parent
                    contentHeight: fileListContent.height
                    clip: true

                    Rectangle {
                        anchors.fill: parent
                        color: "#ffffff99"
                        opacity: 0.3
                    }

                    Column {
                        id: fileListContent
                        width: parent.width

                        Repeater {
                            model: folderModel

                            Rectangle {
                                width: parent.width
                                height: 40
                                color: "#222"

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    text: fileName
                                    color: "white"
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

            /*
            Rectangle {
                id:open_img
                width: 100
                height: 40
                color: "transparent"
                border.color: "#ffffff"

                Text {
                    anchors.centerIn: parent
                    text: "Open"
                    color: "white"
                    font.pixelSize: 25
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("clicked")
                        file_explorer.visible = true
                    }
                }
            }
            */
        }
    }

    Rectangle {
        id: menu_button
        width: 30
        height: 30
        radius: 15
        color: "#80000000"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 15
        z: 20

        Text {
            anchors.centerIn: parent
            text: "≡"
            font.pixelSize: 30
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                menu_panel.visible = !menu_panel.visible
                setting_panel.visible = false
            }
        }
    }

    Image {
        id: setting_button
        width: 30
        height: 30
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins:15
        source: "res/setting_w.png"
        z: 20

        MouseArea {
            anchors.fill: parent
            onClicked: {
                setting_panel.visible = !setting_panel.visible
                menu_panel.visible = false
            }
        }
    }

    Rectangle {
        id: setting_panel
        width: parent.width * 0.6
        height: parent.height
        color: "#d5121200"
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
                color: "white"
            }

            // Brightness Scroll Bar
            Item {
                id: bsb
                width: 420
                height: 40

                property real value: 80
                property real minValue: 0
                property real maxValue: 100

                Rectangle {
                    anchors.fill: parent
                    radius: 12
                    color: "#202020"
                    opacity: 0.95
                }

                Image {
                    source: "res/brightness_w.png"
                    width: 22
                    height: 22
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                }

                // 滑轨
                Item {
                    id: track
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    height: 20

                    // 灰色底轨
                    Rectangle {
                        id: bg
                        height: 4
                        width: parent.width
                        radius: 2
                        color: "#3a3a3a"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // 橙色进度
                    /*
                    Rectangle {'
                        id: fill
                        height: 4
                        radius: 2
                        color: "#ff7a3c"
                        anchors.left: bg.left
                        anchors.verticalCenter: bg.verticalCenter
                        width: handle.x + handle.width / 2
                    }
                    */

                    // 拖动手柄
                    Rectangle {
                        id: handle
                        width: 14
                        height: 14
                        radius: 7
                        color: sliderMouse.pressed ? "#ff9c6b" : "#ff7a3c"
                        border.color: "#ffb08a"
                        border.width: 1
                        y: bg.y + bg.height / 2 - height / 2

                        x: (bsb.value - bsb.minValue) /
                           (bsb.maxValue - bsb.minValue) *
                           (track.width - width)

                        Behavior on x {
                            NumberAnimation { duration: 80 }
                        }
                    }

                    // 拖动逻辑
                    MouseArea {
                        id: sliderMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onPressed: {
                            update(mouse.x)
                            throttleTimer.start()
                        }

                        onPositionChanged: if (pressed) {
                            update(mouse.x)   // UI 仍然高频
                        }

                        onReleased: {
                            throttleTimer.stop()
                            //backend.setValue(bsb.value)  // ✅ 最后再补一次
                        }


                        function update(px) {
                            var w = track.width - handle.width
                            var x = Math.min(w, Math.max(0, px - handle.width / 2))
                            handle.x = x
                            bsb.value = bsb.minValue + (x / w) * (bsb.maxValue - bsb.minValue)

                            // console.log("value =", bsb.value)
                        }
                    }


                    Timer {
                        id: throttleTimer
                        interval: 500    // ✅ 50ms = 20Hz
                        repeat: true
                        running: false
                        onTriggered: {
                            console.log("限频输出:", bsb.value)
                        }
                    }
                }
            }

            Rectangle {
                id: rectangle
                width: 120
                height: 40
                color: "#323232"
                radius: 6

                Text {
                    text: "Personalize"
                    anchors.centerIn: parent
                    font.pointSize: 12
                    font.bold: true
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        calibPage.visible = true   // ✅ 打开全屏页面
                    }
                }
            }
        }
    }

    property real overlay_opacity: 0.3

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "black"
        opacity: overlay_opacity
        z: 900
    }

    Timer {
        interval: 500   // ✅ 10Hz 控制频率（很稳）
        running: true
        repeat: true

        onTriggered: {
            let L_measured = Brightness.readScreenLuminance() * 100
            let L_target   = bsb.value          // ✅ 目标亮度 = 滑条给定 %
            let error      = L_target - L_measured

            let k = 0.005   // ✅ 比例系数（你可以微调）

            overlay_opacity -= k * error

            // ✅ 饱和限制，防止溢出
            if (overlay_opacity < 0.1) overlay_opacity = 0.1
            if (overlay_opacity > 0.7) overlay_opacity = 0.7

            console.log("L_measured =", L_measured,
                        "L_target =", L_target,
                        "opacity =", overlay_opacity)
        }
    }

    // ===== 全屏个性化标定页面 =====
    Item {
        id: calibPage
        anchors.fill: parent
        visible: false
        z: 1000

        // ===== 背景 =====
        Rectangle {
            anchors.fill: parent
            color: "black"
        }

        // ===== 顶部标题 =====
        Text {
            text: "RGB Personal Luminance Calibration"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            color: "white"
            font.pointSize: 20
            font.bold: true
        }

        // ===== 三色标定区域 =====
        Row {
            id: rgbRow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 80
            spacing: 40

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

        // ===== 底部按钮区 =====
        Row {
            spacing: 30
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 30

            // 重置按钮
            Rectangle {
                width: 120
                height: 40
                radius: 6
                color: "#555"

                Text {
                    anchors.centerIn: parent
                    text: "Reset"
                    color: "white"
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        redPanel.alpha   = 0.5
                        greenPanel.alpha = 0.5
                        bluePanel.alpha  = 0.5
                    }
                }
            }

            // 确认按钮
            Rectangle {
                width: 140
                height: 40
                radius: 6
                color: "#ff7a3c"

                Text {
                    anchors.centerIn: parent
                    text: "Confirm"
                    color: "white"
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        let r = 1 - redPanel.alpha
                        let g = 1 - greenPanel.alpha
                        let b = 1 - bluePanel.alpha
                        let s = r + g + b

                        let wR = r / s
                        let wG = g / s
                        let wB = b / s

                        console.log("User RGB Weights:", wR, wG, wB)

                        // ✅ 这里你后面可以接 C++ / Settings 保存
                        // userWR = wR
                        // userWG = wG
                        // userWB = wB

                        calibPage.visible = false
                    }
                }
            }
        }

        // ===== 关闭按钮（右上角）=====
        Rectangle {
            width: 100
            height: 40
            radius: 6
            color: "#444"
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 20

            Text {
                anchors.centerIn: parent
                text: "Close"
                color: "white"
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: calibPage.visible = false
            }
        }
    }


}
