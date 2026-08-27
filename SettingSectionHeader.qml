import QtQuick
import QtQuick.Controls

Rectangle {
    property string title: ""
    width: parent ? parent.width : 0
    height: 48
    color: "transparent"
    opacity: 0
    Component.onCompleted: { opacity = 1 }
    Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }

    Rectangle {
        anchors.left: parent.left; anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1; color: "#c9a84c"; opacity: 0.3
    }
    Label {
        text: parent.title
        color: "#c9a84c"
        font.pixelSize: 13
        font.bold: true
        font.letterSpacing: 2
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.7
    }
}
