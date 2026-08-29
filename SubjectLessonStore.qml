import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    property string subjectId: "arabic"
    property string subjectTitle: "Arabic"
    property var backend: typeof lessonStoreBackend !== "undefined" && lessonStoreBackend !== null ? lessonStoreBackend : null
    property int selectedPart: 1

    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: "#1a1a2e"

    readonly property var parts: backend !== null ? backend.partsForSubject(subjectId) : []
    property var lessons: backend !== null ? backend.lessonsForPart(subjectId, selectedPart) : []

    function refreshLessons() {
        lessons = backend !== null ? backend.lessonsForPart(subjectId, selectedPart) : []
    }

    Component.onCompleted: {
        console.log(subjectTitle + " lesson store backend available:", backend !== null)
        if (backend !== null)
            backend.refreshConfig()
        refreshLessons()
    }

    Connections {
        target: root.backend

        function onStatusChanged() {
            statusText.text = root.backend.status
        }
    }

    Label {
        id: headingLbl
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 24
        text: "📖 " + root.subjectTitle
        color: "#c9a84c"
        font.pixelSize: 28
        font.bold: true
        z: 2
    }

    ScrollView {
        anchors.top: headingLbl.bottom
        anchors.topMargin: 18
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true

        Column {
            width: root.width
            spacing: 14
            padding: 16

            Rectangle {
                width: root.width - 32
                height: 92
                radius: 14
                color: "#0d1b36"
                border.color: "#c9a84c"
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 6

                    Label {
                        text: "Download Store API"
                        color: "#ffffff"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    Label {
                        id: statusText
                        width: parent.width
                        text: root.backend !== null ? root.backend.status : "C++ lesson store backend unavailable"
                        color: "#9badc8"
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        width: parent.width
                        text: root.backend !== null ? root.backend.configUrl : "No config URL"
                        color: "#6d7f9f"
                        font.pixelSize: 11
                        elide: Text.ElideRight
                    }
                }
            }

            Label {
                text: "Parts"
                color: "#c9a84c"
                font.pixelSize: 18
                font.bold: true
            }

            Flow {
                width: root.width - 32
                spacing: 10

                Repeater {
                    model: root.parts

                    delegate: Rectangle {
                        id: partCard
                        width: 150
                        height: 54
                        radius: 12
                        color: root.selectedPart === modelData.number ? "#c9a84c" : "#0d1b36"
                        border.color: "#c9a84c"
                        border.width: 1

                        Label {
                            anchors.centerIn: parent
                            text: modelData.name
                            color: root.selectedPart === modelData.number ? "#0d1b36" : "#c9a84c"
                            font.pixelSize: 15
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                root.selectedPart = modelData.number
                                root.refreshLessons()
                            }
                        }
                    }
                }
            }

            Label {
                text: root.subjectTitle + " Part " + root.selectedPart + " Lessons"
                color: "#c9a84c"
                font.pixelSize: 18
                font.bold: true
            }

            Repeater {
                model: root.lessons

                delegate: Rectangle {
                    width: root.width - 32
                    height: 118
                    radius: 14
                    color: "#0d1b36"
                    border.color: "#c9a84c55"
                    border.width: 1

                    Column {
                        anchors.left: parent.left
                        anchors.right: actionRow.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 14
                        spacing: 5

                        Label {
                            text: modelData.title
                            color: "#ffffff"
                            font.pixelSize: 17
                            font.bold: true
                        }

                        Label {
                            width: parent.width
                            text: "Lesson: " + modelData.lessonPath
                            color: "#9badc8"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }

                        Label {
                            width: parent.width
                            text: "Test: " + modelData.testPath
                            color: "#9badc8"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }

                        Label {
                            text: "Status: " + modelData.status
                            color: "#c9a84c"
                            font.pixelSize: 12
                        }
                    }

                    Row {
                        id: actionRow
                        anchors.right: parent.right
                        anchors.rightMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8

                        Button {
                            text: "Lesson"
                            onClicked: {
                                if (root.backend !== null)
                                    root.backend.downloadNapf(root.subjectId, root.selectedPart, modelData.number, "lesson")
                            }
                        }

                        Button {
                            text: "Test"
                            onClicked: {
                                if (root.backend !== null)
                                    root.backend.downloadNapf(root.subjectId, root.selectedPart, modelData.number, "test")
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: root.width - 32
                height: 92
                radius: 14
                color: "#130f20"
                border.color: "#6d7f9f"
                border.width: 1

                Label {
                    anchors.fill: parent
                    anchors.margins: 14
                    text: "Pending API hooks: YAML config download, NAPF download, tar.xz extraction, manifest parsing, asset resolving, lesson QML loading, quizzes, randomization, progress saving, audio, and 3D model viewer."
                    color: "#9badc8"
                    font.pixelSize: 13
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Item {
                width: 1
                height: 32
            }
        }
    }
}
