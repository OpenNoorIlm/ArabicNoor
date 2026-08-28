import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 2.15
import QtQuick.Studio.DesignEffects
import QtQuick.Studio.Components
import QtQuick.Timeline 1.0

ApplicationWindow {
    id: window
    width: Screen.width
    height: Screen.height
    visible: true
    visibility: Window.Maximized

    background: Rectangle {
        color: "#1a1a2e"
        border.color: "#c9a84c"
        border.width: 12
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "HomePage.qml"

        pushEnter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic }
            NumberAnimation { property: "x"; from: stackView.width; to: 0; duration: 400; easing.type: Easing.OutCubic }
        }
        pushExit: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 400; easing.type: Easing.OutCubic }
            NumberAnimation { property: "x"; from: 0; to: -stackView.width * 0.3; duration: 400; easing.type: Easing.OutCubic }
        }
        popEnter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic }
            NumberAnimation { property: "x"; from: -stackView.width * 0.3; to: 0; duration: 400; easing.type: Easing.OutCubic }
        }
        popExit: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 400; easing.type: Easing.OutCubic }
            NumberAnimation { property: "x"; from: 0; to: stackView.width; duration: 400; easing.type: Easing.OutCubic }
        }
    }

    Button {
        id: menuBtn
        width: 95
        height: 55
        text: "☰"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 8
        anchors.leftMargin: 16
        anchors.topMargin: 19
        icon.color: "#c9a84c"
        onClicked: sidebar.open()

        scale: menuBtn.pressed ? 0.88 : 1.0

        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutBack
            }
        }

        DesignEffect {
            effects: [
                DesignDropShadow {
                }
            ]
        }
    }

    Drawer {
        id: sidebar
        width: 200
        height: window.height
        edge: Qt.LeftEdge

        enter: Transition {
            NumberAnimation {
                property: "position"
                from: 0.0
                to: 1.0
                duration: 500
                easing.type: Easing.OutCubic
            }
        }

        exit: Transition {
            NumberAnimation {
                property: "position"
                from: 1.0
                to: 0.0
                duration: 400
                easing.type: Easing.InCubic
            }
        }

        background: Rectangle {
            color: "#162447"
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                height: 80
                color: "#0d1b36"

                Rectangle {
                    anchors.fill: parent
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#0d1b36" }
                        GradientStop { position: 0.5; color: "#1a2f5a" }
                        GradientStop { position: 1.0; color: "#0d1b36" }
                    }

                    SequentialAnimation on opacity {
                        running: true
                        loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 0.4; duration: 1800; easing.type: Easing.InOutSine }
                        NumberAnimation { from: 0.4; to: 1.0; duration: 1800; easing.type: Easing.InOutSine }
                    }
                }

                Label {
                    text: "نور عربي"
                    color: "#c9a84c"
                    font.pixelSize: 22
                    font.bold: true
                    anchors.centerIn: parent

                    SequentialAnimation on scale {
                        running: true
                        loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 1.05; duration: 1800; easing.type: Easing.InOutSine }
                        NumberAnimation { from: 1.05; to: 1.0; duration: 1800; easing.type: Easing.InOutSine }
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#c9a84c"; opacity: 0.3 }

            Repeater {
                model: [
                    { icon: "🏠", label: "Home",                  page: "HomePage.qml" },
                    { icon: "📖", label: "Quran",                 page: "QuranPage.qml" },
                    { icon: "🕌", label: "Prayer Times",          page: "PrayerTimesPage.qml" },
                    { icon: "📚", label: "Subjects",              page: "SubjectsPage.qml" },
                    { icon: "🔖", label: "Bookmarks",             page: "BookmarksPage.qml" },
                    { icon: "⚙️", label: "Settings",              page: "SettingsPage.qml" },
                    { icon: "📖", label: "Info of Sarf Subject",  page: "AboutSarf.qml" },
                    { icon: "📖", label: "Info of Nahw Subject",  page: "AboutNahw.qml" },
                    { icon: "📖", label: "Info of Arabic Subject",page: "AboutArabic.qml" }
                ]

                delegate: Rectangle {
                    id: navItem
                    Layout.fillWidth: true
                    height: 52
                    color: drawerItemMouse.containsMouse ? "#1e3a6e" : drawerItemMouse.pressed ? "#c9a84c22" : "transparent"
                    opacity: 0
                    x: -30

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }

                    Component.onCompleted: {
                        fadeIn.delay = index * 60
                        fadeIn.start()
                    }

                    ParallelAnimation {
                        id: fadeIn
                        property int delay: 0
                        NumberAnimation {
                            target: navItem
                            property: "opacity"
                            from: 0; to: 1
                            duration: 350
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: navItem
                            property: "x"
                            from: -30; to: 0
                            duration: 350
                            easing.type: Easing.OutCubic
                        }
                    }

                    Rectangle {
                        id: glowBar
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: drawerItemMouse.containsMouse ? 3 : 0
                        color: "#c9a84c"
                        radius: 2

                        Behavior on width {
                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }

                        SequentialAnimation on opacity {
                            running: drawerItemMouse.containsMouse
                            loops: Animation.Infinite
                            NumberAnimation { from: 1.0; to: 0.4; duration: 600; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 0.4; to: 1.0; duration: 600; easing.type: Easing.InOutSine }
                        }
                    }

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        spacing: 12

                        Label {
                            text: modelData.icon
                            font.pixelSize: 18
                            anchors.verticalCenter: parent.verticalCenter

                            scale: drawerItemMouse.containsMouse ? 1.2 : 1.0
                            Behavior on scale {
                                NumberAnimation { duration: 200; easing.type: Easing.OutBack }
                            }
                        }

                        Label {
                            text: modelData.label
                            color: drawerItemMouse.containsMouse ? "#ffffff" : "#c9a84c"
                            font.pixelSize: 15
                            anchors.verticalCenter: parent.verticalCenter

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }
                    }

                    MouseArea {
                        id: drawerItemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            stackView.replace(modelData.page)
                            sidebar.close()
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#c9a84c"; opacity: 0.3 }

            Rectangle {
                Layout.fillWidth: true
                height: 52
                color: "transparent"

                Label {
                    text: "v0.1.0  •  NoorArabic"
                    color: "#c9a84c"
                    opacity: 0.4
                    font.pixelSize: 11
                    anchors.centerIn: parent
                }
            }
        }
    }
}
