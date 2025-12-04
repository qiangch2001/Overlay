import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.folderlistmodel 2.15

Window {
    width: Screen.width
    height: Screen.height
    // visible: true
    color: "black"

    property string selected_image: ""

    Image {
        anchors.fill: parent
        source: selected_image != "" ? selected_image : "res/img1.jpg"
        fillMode: Image.PreserveAspectFit
        z: 0
    }

    property bool menu_open: false

    Rectangle {
        id: menu_panel
        width: parent.width * 0.3
        height: parent.width
        color: "#d5c8c800"
        anchors.right: parent.right
        z: 10
        visible: menu_open

        Column {
            id: column
            spacing: 10
            anchors.margins: 20
            anchors.fill: parent

            Text {
                text: "Settings"
                anchors.left: parent.left
                anchors.leftMargin: 60
                font.bold: true
                font.pointSize: 30
                color: "white"
            }

            Rectangle {
                id:open_img
                width: 120
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
                    }
                }
            }
            // FolderListModel（注意：不能用 qrc）
            FolderListModel {
                id: folderModel
                folder: "/root"  // 改成真实目录
                nameFilters: ["*.*"]
            }

            // 文件列表（可滚动）
            Flickable {
                id: flick
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: parent.height - 100
                contentHeight: fileListContent.height

                Column {
                    id: fileListContent
                    width: flick.width

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
                                    selectedImage = filePath
                                    file_explorer.visible = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: menu_button
        width: 50
        height: 50
        radius: 25
        color: "#80000000"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
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

    Rectangle {
        id: file_explorer
        visible: false
        z: 50
        anchors.fill: parent
        color: "black"

        Column {
            anchors.fill: parent
            anchors.margins: 20

            Text {
                text: "Select Image"
                font.bold: true
                font.pointSize: 20
                color: "white"
            }



            Rectangle {
                width: parent.width
                height: parent.height - 120   // 给 ListView 合理高度
                color: "white"

                ListView {
                    anchors.fill: parent

                    FolderListModel {
                        id: folder_model
                        nameFilters: ["*.*"]
                        folder: "/root"
                    }

                    model: folder_model

                    delegate: Rectangle {
                        width: parent.width
                        height: 40

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: fileName
                            color: "black"
                        }

                        /*MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                selectedImage = filePath
                                file_explorer.visible = false
                            }
                        }*/
                    }
                }
            }

            Button {
                text: "Close"
                onClicked: file_explorer.visible = false
            }
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
