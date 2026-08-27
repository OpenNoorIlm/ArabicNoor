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
        id: prayerLbl
        anchors.centerIn: parent
        text: "📚 Prayers"
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
            target: prayerLbl
            property: "x"
            Keyframe {
                value: window.width * 0.5 - prayerLbl.width * 0.5
                frame: 0
            }
            Keyframe {
                value: window.width * 0.5 - prayerLbl.width * 0.5
                frame: 60
            }

            Keyframe {
                value: 883
                frame: 70
            }
        }

        KeyframeGroup {
            target: prayerLbl
            property: "y"
            Keyframe {
                value: -prayerLbl.height
                frame: 0
            }
            Keyframe {
                easing.type: Easing.OutCubic
                value: window.height * 0.5 - prayerLbl.height * 0.5
                frame: 60
            }

            Keyframe {
                value: 24
                frame: 70
            }
        }

        KeyframeGroup {
            target: prayerLbl
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

}

