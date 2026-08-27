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
        id: quranLbl
        anchors.centerIn: parent
        text: "📚 Quran"
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
            target: quranLbl
            property: "x"
            Keyframe {
                value: window.width * 0.5 - quranLbl.width * 0.5
                frame: 0
            }
            Keyframe {
                value: window.width * 0.5 - quranLbl.width * 0.5
                frame: 60
            }

            Keyframe {
                value: 883
                frame: 70
            }
        }

        KeyframeGroup {
            target: quranLbl
            property: "y"
            Keyframe {
                value: -quranLbl.height
                frame: 0
            }
            Keyframe {
                easing.type: Easing.OutCubic
                value: window.height * 0.5 - quranLbl.height * 0.5
                frame: 60
            }

            Keyframe {
                value: 24
                frame: 70
            }
        }

        KeyframeGroup {
            target: quranLbl
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

