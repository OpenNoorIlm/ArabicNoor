import QtQuick
import QtQuick.Timeline 1.0

Rectangle {
    id: homePage
    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: "#1a1a2e"

    Text {
        id: appNameText
        x: 256
        y: -44
        text: qsTr("NoorArabic")
        font.pixelSize: 31
        color: "#c9a84c"
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
            }
        ]
        startFrame: 0
        endFrame: 70
        enabled: true

        KeyframeGroup {
            target: appNameText
            property: "x"
            Keyframe {
                value: homePage.width * 0.5 - appNameText.width * 0.5
                frame: 0
            }
            Keyframe {
                value: homePage.width * 0.5 - appNameText.width * 0.5
                frame: 60
            }
            Keyframe {
                value: 883
                frame: 70
            }
        }

        KeyframeGroup {
            target: appNameText
            property: "y"
            Keyframe {
                value: -appNameText.height
                frame: 0
            }
            Keyframe {
                easing.type: Easing.OutCubic
                value: homePage.height * 0.5 - appNameText.height * 0.5
                frame: 60
            }
            Keyframe {
                value: 24
                frame: 70
            }
        }

        KeyframeGroup {
            target: appNameText
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
}
