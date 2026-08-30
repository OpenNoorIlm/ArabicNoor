import QtQuick
import QtQuick.Controls

Rectangle {
    id: subjectsPage
    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: "#1a1a2e"

    property real pageMargin: Math.max(16, Math.min(width * 0.05, 48))
    property real contentWidth: Math.min(width - pageMargin * 2, 760)

    Column {
        id: contentColumn
        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
        width: subjectsPage.contentWidth
        spacing: Math.max(14, subjectsPage.height * 0.025)

        Label {
            text: "📚 Subjects"
            color: "#c9a84c"
            font.pixelSize: Math.max(24, Math.min(subjectsPage.width * 0.045, 34))
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            width: parent.width
            text: "Choose a subject to open its lesson store."
            color: "#9badc8"
            font.pixelSize: Math.max(13, Math.min(subjectsPage.width * 0.018, 16))
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Repeater {
            model: [
                { title: "Sarf", subtitle: "Word forms and morphology", page: "SarfPage.qml" },
                { title: "Nahw", subtitle: "Grammar and sentence structure", page: "NahwPage.qml" },
                { title: "Arabic", subtitle: "Arabic language lessons", page: "ArabicPage.qml" }
            ]

            delegate: Button {
                id: subjectButton
                width: parent.width
                height: Math.max(82, Math.min(subjectsPage.height * 0.14, 120))
                text: modelData.title
                opacity: 0

                Component.onCompleted: subjectButtonFadeIn.start()

                ParallelAnimation {
                    id: subjectButtonFadeIn
                    NumberAnimation {
                        target: subjectButton
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 420 + index * 80
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: subjectButton
                        property: "scale"
                        from: 0.92
                        to: 1.0
                        duration: 420 + index * 80
                        easing.type: Easing.OutBack
                    }
                }

                scale: pressed ? 0.97 : hovered ? 1.02 : 1.0
                Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutBack } }

                background: Rectangle {
                    radius: 16
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: subjectButton.hovered ? "#2a4a8a" : "#162447" }
                        GradientStop { position: 1.0; color: subjectButton.hovered ? "#1a2f5a" : "#0d1b36" }
                    }
                    border.color: subjectButton.hovered ? "#c9a84c" : "#8b6914"
                    border.width: subjectButton.hovered ? 2 : 1
                }

                contentItem: Column {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 4

                    Text {
                        width: parent.width
                        text: subjectButton.text
                        color: subjectButton.hovered ? "#ffffff" : "#c9a84c"
                        font.pixelSize: Math.max(22, Math.min(subjectsPage.width * 0.04, 34))
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        width: parent.width
                        text: modelData.subtitle
                        color: "#9badc8"
                        font.pixelSize: Math.max(12, Math.min(subjectsPage.width * 0.017, 15))
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                }

                onClicked: stackView.replace(modelData.page)
            }
        }
    }
}
