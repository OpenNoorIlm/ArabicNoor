import QtQuick
import QtQuick.Controls

Rectangle {
    id: sRow
    property string label: ""
    property string sublabel: ""
    property bool hasToggle: false
    property bool hasChevron: false
    property bool toggleValue: false
    property int animDelay: 0
    signal toggled(bool val)
    signal tapped()

    width: parent ? parent.width : 0
    height: sublabel !== "" ? 68 : 52
    color: rowMouse.containsMouse ? "#1e3a6e" : "transparent"
    opacity: 0
    clip: false

    Behavior on color { ColorAnimation { duration: 200 } }

    Component.onCompleted: rowAnim.start()

    SequentialAnimation {
        id: rowAnim
        PauseAnimation { duration: sRow.animDelay }
        ParallelAnimation {
            NumberAnimation { target: sRow; property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic }
            NumberAnimation { target: sRow; property: "x"; from: -30; to: 0; duration: 400; easing.type: Easing.OutCubic }
        }
    }

    Rectangle {
        anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
        width: rowMouse.containsMouse ? 3 : 0; color: "#c9a84c"; radius: 2
        Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    }

    Column {
        anchors.left: parent.left; anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3
        Label {
            text: sRow.label
            color: rowMouse.containsMouse ? "#ffffff" : "#c9a84c"
            font.pixelSize: 15
            Behavior on color { ColorAnimation { duration: 200 } }
        }
        Label {
            visible: sRow.sublabel !== ""
            text: sRow.sublabel
            color: "#7a8aaa"
            font.pixelSize: 12
        }
    }

    Rectangle {
        visible: sRow.hasToggle
        anchors.right: parent.right; anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        width: 44; height: 24; radius: 12
        color: sRow.toggleValue ? "#c9a84c" : "#2a3a5a"
        Behavior on color { ColorAnimation { duration: 250 } }

        Rectangle {
            x: sRow.toggleValue ? 22 : 2
            anchors.verticalCenter: parent.verticalCenter
            width: 20; height: 20; radius: 10
            color: "#ffffff"
            Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: sRow.toggled(!sRow.toggleValue)
        }
    }

    Label {
        visible: sRow.hasChevron
        text: "›"
        color: "#c9a84c"
        font.pixelSize: 22
        anchors.right: parent.right; anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        opacity: rowMouse.containsMouse ? 1.0 : 0.4
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    Rectangle {
        anchors.left: parent.left; anchors.right: parent.right
        anchors.bottom: parent.bottom; anchors.leftMargin: 16
        height: 1; color: "#c9a84c"; opacity: 0.08
    }

    MouseArea {
        id: rowMouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: sRow.tapped()
    }
}
