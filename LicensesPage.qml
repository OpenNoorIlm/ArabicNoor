import QtQuick
import QtQuick.Controls
import QtQuick.Timeline 1.0

Rectangle {
    id: licensesRoot
    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: "#1a1a2e"
    property var settingsStackView: StackView.view
    Label {
        id: licensesLbl
        text: "📄 Licenses"
        color: "#c9a84c"
        font.pixelSize: 28
        font.bold: true
        z: 2
    }

    Timeline {
        id: timeline
        animations: [ TimelineAnimation { running: true; loops: 1; to: 70; from: 0; duration: 1200 } ]
        startFrame: 0; endFrame: 70; enabled: true
        KeyframeGroup {
            target: licensesLbl; property: "x"
            Keyframe { value: licensesRoot.width * 0.5 - licensesLbl.width * 0.5; frame: 0 }
            Keyframe { value: licensesRoot.width * 0.5 - licensesLbl.width * 0.5; frame: 60 }
            Keyframe { value: 883; frame: 70 }
        }
        KeyframeGroup {
            target: licensesLbl; property: "y"
            Keyframe { value: -licensesLbl.height; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: licensesRoot.height * 0.5 - licensesLbl.height * 0.5; frame: 60 }
            Keyframe { value: 24; frame: 70 }
        }
        KeyframeGroup {
            target: licensesLbl; property: "opacity"
            Keyframe { value: 0; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: 1; frame: 60 }
        }
    }

    ScrollView {
        anchors.top: parent.top; anchors.topMargin: 70
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        anchors.leftMargin: 40; anchors.rightMargin: 40
        clip: true

        Column {
            width: licensesRoot.width - 80
            spacing: 0

            Repeater {
                model: [
                    { name: "NoorArabic", version: "—", license: "MIT License", url: "View included LICENSE file", action: "showLicense" },
                    { name: "Qt Framework", version: "6.11.2", license: "LGPL v3", url: "https://www.qt.io" },
                    { name: "Qt Design Studio", version: "4.8.3", license: "Commercial / GPL v3", url: "https://www.qt.io/product/ui-design-tools" },
                    { name: "Al Quran Cloud API", version: "v1", license: "Online Quran data service", url: "https://alquran.cloud/api" },
                    { name: "AlAdhan Prayer Times API", version: "v1", license: "Online prayer-time service", url: "https://aladhan.com/prayer-times-api" },
                    { name: "Karachi Calculation Method", version: "1", license: "University of Islamic Sciences, Karachi", url: "https://aladhan.com/calculation-methods" }
                ]

                delegate: Rectangle {
                    id: licCard
                    width: parent.width
                    height: licCol.implicitHeight + 24
                    radius: 10
                    color: licMouse.containsMouse ? "#162447" : "#0d1b36"
                    border.color: licMouse.containsMouse ? "#c9a84c" : "#1e3a6e"
                    border.width: 1
                    opacity: 0
                    Behavior on color { ColorAnimation { duration: 200 } }
                    Behavior on border.color { ColorAnimation { duration: 200 } }

                    Component.onCompleted: licAnim.start()
                    SequentialAnimation {
                        id: licAnim
                        PauseAnimation { duration: index * 80 }
                        ParallelAnimation {
                            NumberAnimation { target: licCard; property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic }
                            NumberAnimation { target: licCard; property: "x"; from: -30; to: 0; duration: 400; easing.type: Easing.OutCubic }
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
                        width: licMouse.containsMouse ? 3 : 0; radius: 2; color: "#c9a84c"
                        Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                    }

                    Column {
                        id: licCol
                        anchors.left: parent.left; anchors.right: parent.right
                        anchors.top: parent.top; anchors.margins: 16
                        spacing: 4

                        Label {
                            text: modelData.name
                            color: licMouse.containsMouse ? "#ffffff" : "#c9a84c"
                            font.pixelSize: 16; font.bold: true
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                        Row {
                            spacing: 16
                            Label { text: "v" + modelData.version; color: "#7a8aaa"; font.pixelSize: 13 }
                            Label { text: "•"; color: "#3a4a6a"; font.pixelSize: 13 }
                            Label { text: modelData.license; color: "#c9a84c"; font.pixelSize: 13 }
                        }
                        Label {
                            visible: modelData.url !== ""
                            text: modelData.url
                            color: "#4a7abf"
                            font.pixelSize: 12
                            font.underline: true
                        }
                    }

                    MouseArea {
                        id: licMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: (modelData.action === "showLicense" || modelData.url !== "")
                                     ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            if (modelData.action === "showLicense") {
                                licensesRoot.settingsStackView.push("LicenseTextPage.qml")
                            } else if (modelData.url !== "") {
                                Qt.openUrlExternally(modelData.url)
                            }
                        }
                    }
                }
            }

            Item { width: 1; height: 60 }
        }
    }
}
