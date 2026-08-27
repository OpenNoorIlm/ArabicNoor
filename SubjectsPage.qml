import QtQuick
import QtQuick.Controls
import QtQuick.Timeline 1.0
import QtQuick.Studio.DesignEffects
import QtQuick.Studio.Components

Rectangle {
    id: rectangle
    width: Screen.width
    height: Screen.height
    color: "#1a1a2e"

    Label {
        id: subjectLbl
        anchors.centerIn: parent
        text: "📚 Subjects"
        color: "#c9a84c"
        font.pixelSize: 28
        anchors.verticalCenterOffset: -500
        anchors.horizontalCenterOffset: 0
        font.bold: true

        DesignEffect {
            effects: [
                DesignDropShadow {
                }
            ]
        }
    }

    Timeline {
        id: timeline
        animations: [
            TimelineAnimation {
                id: dropAnim
                pingPong: false
                running: true
                loops: 1
                to: 70
                from: 0
                duration: 1200
            },
            TimelineAnimation {
                id: timelineAnimation
                running: false
                loops: 1
                to: 70
                from: 0
            }
        ]
        startFrame: 0
        endFrame: 70
        enabled: true

        KeyframeGroup {
            target: subjectLbl
            property: "x"
            Keyframe {
                value: window.width * 0.5 - subjectLbl.width * 0.5
                frame: 0
            }
            Keyframe {
                value: window.width * 0.5 - subjectLbl.width * 0.5
                frame: 60
            }

            Keyframe {
                value: 883
                frame: 70
            }
        }

        KeyframeGroup {
            target: subjectLbl
            property: "y"
            Keyframe {
                value: -subjectLbl.height
                frame: 0
            }
            Keyframe {
                easing.type: Easing.OutCubic
                value: window.height * 0.5 - subjectLbl.height * 0.5
                frame: 60
            }

            Keyframe {
                value: 24
                frame: 70
            }
        }

        KeyframeGroup {
            target: subjectLbl
            property: "opacity"
            Keyframe {
                value: 0
                frame: 0
            }
            Keyframe {
                easing.type: Easing.OutCubic
                value: 1
                frame: 60
            }
        }
    }

    DesignEffect {
        effects: [
            DesignInnerShadow {
            }
        ]
    }

    Button {
        id: sarfBtn
        text: qsTr("Sarf")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 748
        anchors.rightMargin: 748
        anchors.topMargin: 326
        anchors.bottomMargin: 629
        icon.color: "#c9a749"
        font.pointSize: 35
        display: AbstractButton.TextUnderIcon
        clip: false
        opacity: 0

        Component.onCompleted: sarfFadeIn.start()

        ParallelAnimation {
            id: sarfFadeIn
            NumberAnimation { target: sarfBtn; property: "opacity"; from: 0; to: 1; duration: 500; easing.type: Easing.OutCubic }
            NumberAnimation { target: sarfBtn; property: "scale"; from: 0.7; to: 1.0; duration: 500; easing.type: Easing.OutBack }
        }

        scale: sarfBtn.pressed ? 0.92 : sarfBtnMouse.containsMouse ? 1.06 : 1.0
        Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutBack } }

        background: Rectangle {
            radius: 16
            gradient: Gradient {
                GradientStop { position: 0.0; color: sarfBtnMouse.containsMouse ? "#2a4a8a" : "#162447" }
                GradientStop { position: 1.0; color: sarfBtnMouse.containsMouse ? "#1a2f5a" : "#0d1b36" }
            }
            border.color: sarfBtnMouse.containsMouse ? "#c9a84c" : "#8b6914"
            border.width: sarfBtnMouse.containsMouse ? 2 : 1
            Behavior on border.width { NumberAnimation { duration: 200 } }

            Rectangle {
                id: sarfGlow
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                border.color: "#c9a84c"
                border.width: 0
                opacity: 0.6
                visible: sarfBtnMouse.containsMouse
                SequentialAnimation on border.width {
                    running: sarfBtnMouse.containsMouse
                    loops: Animation.Infinite
                    NumberAnimation { from: 2; to: 5; duration: 700; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 5; to: 2; duration: 700; easing.type: Easing.InOutSine }
                }
            }
        }

        contentItem: Text {
            text: sarfBtn.text
            font: sarfBtn.font
            color: sarfBtnMouse.containsMouse ? "#ffffff" : "#c9a84c"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        MouseArea {
            id: sarfBtnMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: sarfBtn.clicked()
        }

        DesignEffect {
            effects: [ DesignDropShadow { color: "#80c9a84c" } ]
        }
    }

    Button {
        id: sarfBtn1
        text: qsTr("Nahw")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 748
        anchors.rightMargin: 748
        anchors.topMargin: 589
        anchors.bottomMargin: 366
        icon.color: "#c9a749"
        font.pointSize: 35
        display: AbstractButton.TextUnderIcon
        clip: false
        opacity: 0

        Component.onCompleted: nahwFadeIn.start()

        ParallelAnimation {
            id: nahwFadeIn
            NumberAnimation { target: sarfBtn1; property: "opacity"; from: 0; to: 1; duration: 500; easing.type: Easing.OutCubic; }
            NumberAnimation { target: sarfBtn1; property: "scale"; from: 0.7; to: 1.0; duration: 600; easing.type: Easing.OutBack; }
        }

        scale: sarfBtn1.pressed ? 0.92 : nahwBtnMouse.containsMouse ? 1.06 : 1.0
        Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutBack } }

        background: Rectangle {
            radius: 16
            gradient: Gradient {
                GradientStop { position: 0.0; color: nahwBtnMouse.containsMouse ? "#2a4a8a" : "#162447" }
                GradientStop { position: 1.0; color: nahwBtnMouse.containsMouse ? "#1a2f5a" : "#0d1b36" }
            }
            border.color: nahwBtnMouse.containsMouse ? "#c9a84c" : "#8b6914"
            border.width: nahwBtnMouse.containsMouse ? 2 : 1
            Behavior on border.width { NumberAnimation { duration: 200 } }

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                border.color: "#c9a84c"
                border.width: 0
                opacity: 0.6
                visible: nahwBtnMouse.containsMouse
                SequentialAnimation on border.width {
                    running: nahwBtnMouse.containsMouse
                    loops: Animation.Infinite
                    NumberAnimation { from: 2; to: 5; duration: 700; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 5; to: 2; duration: 700; easing.type: Easing.InOutSine }
                }
            }
        }

        contentItem: Text {
            text: sarfBtn1.text
            font: sarfBtn1.font
            color: nahwBtnMouse.containsMouse ? "#ffffff" : "#c9a84c"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        MouseArea {
            id: nahwBtnMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: sarfBtn1.clicked()
        }

        DesignEffect {
            effects: [ DesignDropShadow { color: "#80c9a84c" } ]
        }
    }

    Button {
        id: sarfBtn2
        text: qsTr("Arabic")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 748
        anchors.rightMargin: 748
        anchors.topMargin: 876
        anchors.bottomMargin: 79
        icon.color: "#c9a749"
        font.pointSize: 35
        display: AbstractButton.TextUnderIcon
        clip: false
        opacity: 0

        Component.onCompleted: arabicFadeIn.start()

        ParallelAnimation {
            id: arabicFadeIn
            NumberAnimation { target: sarfBtn2; property: "opacity"; from: 0; to: 1; duration: 500; easing.type: Easing.OutCubic; }
            NumberAnimation { target: sarfBtn2; property: "scale"; from: 0.7; to: 1.0; duration: 700; easing.type: Easing.OutBack; }
        }

        scale: sarfBtn2.pressed ? 0.92 : arabicBtnMouse.containsMouse ? 1.06 : 1.0
        Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutBack } }

        background: Rectangle {
            radius: 16
            gradient: Gradient {
                GradientStop { position: 0.0; color: arabicBtnMouse.containsMouse ? "#2a4a8a" : "#162447" }
                GradientStop { position: 1.0; color: arabicBtnMouse.containsMouse ? "#1a2f5a" : "#0d1b36" }
            }
            border.color: arabicBtnMouse.containsMouse ? "#c9a84c" : "#8b6914"
            border.width: arabicBtnMouse.containsMouse ? 2 : 1
            Behavior on border.width { NumberAnimation { duration: 200 } }

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                border.color: "#c9a84c"
                border.width: 0
                opacity: 0.6
                visible: arabicBtnMouse.containsMouse
                SequentialAnimation on border.width {
                    running: arabicBtnMouse.containsMouse
                    loops: Animation.Infinite
                    NumberAnimation { from: 2; to: 5; duration: 700; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 5; to: 2; duration: 700; easing.type: Easing.InOutSine }
                }
            }
        }

        contentItem: Text {
            text: sarfBtn2.text
            font: sarfBtn2.font
            color: arabicBtnMouse.containsMouse ? "#ffffff" : "#c9a84c"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        MouseArea {
            id: arabicBtnMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: sarfBtn2.clicked()
        }

        DesignEffect {
            effects: [ DesignDropShadow { color: "#80c9a84c" } ]
        }
    }


}

