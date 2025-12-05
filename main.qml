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

    property bool menu_open: false

    Rectangle {
        id: menu_panel
        width: parent.width * 0.6
        height: parent.height
        color: "#d5c8c800"
        anchors.left: parent.left
        z: 10
        visible: menu_open

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
            onClicked: menu_open = !menu_open
        }
    }

    property real overlay_opacity: 0.3

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "black"
        opacity: overlay_opacity
        z: 999
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            let L = Brightness.readScreenLuminance()
            console.log("Brightness", L)
            overlay_opacity = L / 4
        }
    }
}
