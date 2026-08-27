import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    property string blockText: ""
    property bool isHeading: false
    property bool isArabic: false
    property bool isUrdu: false
    property int animDelay: 0
    property color textColor: "#c9a84c"

    width: parent ? parent.width : 0
    height: lbl.implicitHeight + (isHeading ? 28 : 16)
    color: "transparent"
    opacity: 0
    x: isArabic || isUrdu ? 30 : -30

    Component.onCompleted: blockAnim.start()

    SequentialAnimation {
        id: blockAnim
        PauseAnimation { duration: root.animDelay }
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; from: 0; to: 1; duration: 500; easing.type: Easing.OutCubic }
            NumberAnimation { target: root; property: "x"; to: 0; duration: 500; easing.type: Easing.OutCubic }
        }
    }

    Rectangle {
        visible: root.isHeading
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 3
        radius: 2
        color: "#c9a84c"
        SequentialAnimation on opacity {
            running: root.isHeading
            loops: Animation.Infinite
            NumberAnimation { from: 1.0; to: 0.3; duration: 1200; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.3; to: 1.0; duration: 1200; easing.type: Easing.InOutSine }
        }
    }

    Label {
        id: lbl
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: root.isHeading ? 14 : 4
        anchors.verticalCenter: parent.verticalCenter
        text: root.blockText
        color: root.textColor
        font.pixelSize: root.isHeading ? 20 : 15
        font.bold: root.isHeading
        wrapMode: Text.WordWrap
        horizontalAlignment: root.isArabic || root.isUrdu ? Text.AlignRight : Text.AlignLeft
        textFormat: Text.RichText
    }
}
