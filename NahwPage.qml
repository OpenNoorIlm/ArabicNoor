import QtQuick
import QtQuick.Controls
import QtQuick.Timeline 1.0
import QtQuick.Studio.DesignEffects
import QtQuick.Studio.Components

Rectangle {
    id: nahwPage
    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: "#1a1a2e"

    Label {
        id: headingLbl
        text: "📖 Info of Nahw Subject"
        color: "#c9a84c"
        font.pixelSize: 28
        font.bold: true

        DesignEffect {
            effects: [ DesignDropShadow { } ]
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
            }
        ]
        startFrame: 0
        endFrame: 70
        enabled: true

        KeyframeGroup {
            target: headingLbl
            property: "x"
            Keyframe { value: nahwPage.width * 0.5 - headingLbl.width * 0.5; frame: 0 }
            Keyframe { value: nahwPage.width * 0.5 - headingLbl.width * 0.5; frame: 60 }
            Keyframe { value: 883; frame: 70 }
        }

        KeyframeGroup {
            target: headingLbl
            property: "y"
            Keyframe { value: -headingLbl.height; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: nahwPage.height * 0.5 - headingLbl.height * 0.5; frame: 60 }
            Keyframe { value: 24; frame: 70 }
        }

        KeyframeGroup {
            target: headingLbl
            property: "opacity"
            Keyframe { value: 0; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: 1; frame: 60 }
        }
    }
}
