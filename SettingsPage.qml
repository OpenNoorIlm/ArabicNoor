import QtQuick
import QtQuick.Controls
import QtQuick.Timeline 1.0

Rectangle {
    id: settingsRoot
    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: darkMode ? "#1a1a2e" : "#f4efe2"

    // ── Toggles state ─────────────────────────────────────────────────────
    property var backend: typeof settingsBackend !== "undefined" && settingsBackend !== null ? settingsBackend : null
    property bool darkMode: backend !== null ? backend.darkMode : true
    property bool showTafsir: backend !== null ? backend.showTafsir : false
    property bool showTranslit: backend !== null ? backend.showTransliteration : true
    property bool prayerNotifications: backend !== null ? backend.prayerNotifications : true
    property string choiceTitle: ""
    property string choiceKey: ""
    property string choiceCurrentValue: ""
    property var choiceOptions: []

    function setSettingBool(key, value) {
        if (backend !== null)
            backend.setBool(key, value)
    }

    function setSettingString(key, value) {
        if (backend !== null)
            backend.setString(key, value)
    }

    function openChoice(title, key, currentValue) {
        if (backend === null)
            return

        choiceTitle = title
        choiceKey = key
        choiceCurrentValue = String(currentValue)
        choiceOptions = backend.optionValues(key)
        choiceDialog.open()
    }

    // ── Heading ───────────────────────────────────────────────────────────
    Label {
        id: settingLbl
        text: "⚙️ Settings"
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
            target: settingLbl; property: "x"
            Keyframe { value: settingsRoot.width * 0.5 - settingLbl.width * 0.5; frame: 0 }
            Keyframe { value: settingsRoot.width * 0.5 - settingLbl.width * 0.5; frame: 60 }
            Keyframe { value: Math.max(16, settingsRoot.width - settingLbl.width - 24); frame: 70 }
        }
        KeyframeGroup {
            target: settingLbl; property: "y"
            Keyframe { value: -settingLbl.height; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: settingsRoot.height * 0.5 - settingLbl.height * 0.5; frame: 60 }
            Keyframe { value: 24; frame: 70 }
        }
        KeyframeGroup {
            target: settingLbl; property: "opacity"
            Keyframe { value: 0; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: 1; frame: 60 }
        }
    }

    // ── StackView for sub-pages ───────────────────────────────────────────
    StackView {
        id: settingsStack
        anchors.top: parent.top; anchors.topMargin: 70
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom

        pushEnter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 300; easing.type: Easing.OutCubic }
            NumberAnimation { property: "x"; from: settingsStack.width * 0.3; to: 0; duration: 300; easing.type: Easing.OutCubic }
        }
        pushExit: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 300; easing.type: Easing.OutCubic }
        }
        popEnter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 300; easing.type: Easing.OutCubic }
        }
        popExit: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 300; easing.type: Easing.OutCubic }
            NumberAnimation { property: "x"; from: 0; to: settingsStack.width * 0.3; duration: 300; easing.type: Easing.OutCubic }
        }

        initialItem: settingsMain
    }

    // ── Main settings list ────────────────────────────────────────────────
    Component {
        id: settingsMain

        ScrollView {
            width: parent ? parent.width : 0
            height: parent ? parent.height : 0
            clip: true

            Column {
                width: settingsRoot.width
                spacing: 0

                Rectangle {
                    width: parent.width - 32
                    height: 74
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 14
                    color: "#0d1b36"
                    border.color: "#c9a84c"
                    border.width: 1

                    Column {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: 16
                        spacing: 4

                        Label {
                            text: "Settings are saved automatically"
                            color: "#c9a84c"
                            font.pixelSize: 15
                            font.bold: true
                        }

                        Label {
                            text: "Tap a row to choose from a list. Location can be typed manually."
                            color: "#7a8aaa"
                            font.pixelSize: 12
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                Item { width: 1; height: 10 }

                // ════ APPEARANCE ═════════════════════════════════════════
                SettingSectionHeader { title: "  APPEARANCE" }

                SettingRow {
                    label: "Dark Mode"
                    sublabel: "Deep navy Islamic theme"
                    hasToggle: true
                    toggleValue: settingsRoot.darkMode
                    animDelay: 100
                    onToggled: (val) => settingsRoot.setSettingBool("darkMode", val)
                }
                SettingRow {
                    label: "Gold Accent Colour"
                    sublabel: settingsRoot.backend !== null ? settingsRoot.backend.accentColor : "#c9a84c"
                    hasChevron: true
                    animDelay: 160
                    onTapped: settingsRoot.openChoice(label, "accentColor", settingsRoot.backend.accentColor)
                }
                SettingRow {
                    label: "Font Size"
                    sublabel: settingsRoot.backend !== null ? settingsRoot.backend.fontSize : "Medium"
                    hasChevron: true
                    animDelay: 220
                    onTapped: settingsRoot.openChoice(label, "fontSize", settingsRoot.backend.fontSize)
                }
                SettingRow {
                    label: "Arabic Font"
                    sublabel: settingsRoot.backend !== null ? settingsRoot.backend.arabicFont : "System default"
                    hasChevron: true
                    animDelay: 280
                    onTapped: settingsRoot.openChoice(label, "arabicFont", settingsRoot.backend.arabicFont)
                }

                Item { width: 1; height: 8 }

                // ════ QURAN ══════════════════════════════════════════════
                SettingSectionHeader { title: "  QURAN" }

                SettingRow {
                    label: "Default Translation"
                    sublabel: settingsRoot.backend !== null ? settingsRoot.backend.defaultTranslation : "Kanzul Iman"
                    hasChevron: true
                    animDelay: 360
                    onTapped: settingsRoot.openChoice(label, "defaultTranslation", settingsRoot.backend.defaultTranslation)
                }
                SettingRow {
                    label: "Show Tafsir by Default"
                    hasToggle: true
                    toggleValue: settingsRoot.showTafsir
                    animDelay: 420
                    onToggled: (val) => settingsRoot.setSettingBool("showTafsir", val)
                }
                SettingRow {
                    label: "Show Transliteration"
                    hasToggle: true
                    toggleValue: settingsRoot.showTranslit
                    animDelay: 480
                    onToggled: (val) => settingsRoot.setSettingBool("showTransliteration", val)
                }
                SettingRow {
                    label: "Arabic Script"
                    sublabel: settingsRoot.backend !== null ? settingsRoot.backend.arabicScript : "Uthmani"
                    hasChevron: true
                    animDelay: 540
                    onTapped: settingsRoot.openChoice(label, "arabicScript", settingsRoot.backend.arabicScript)
                }
                SettingRow {
                    label: "Auto-scroll Speed"
                    sublabel: settingsRoot.backend !== null ? settingsRoot.backend.autoScrollSpeed : "Normal"
                    hasChevron: true
                    animDelay: 600
                    onTapped: settingsRoot.openChoice(label, "autoScrollSpeed", settingsRoot.backend.autoScrollSpeed)
                }

                Item { width: 1; height: 8 }

                // ════ PRAYER TIMES ═══════════════════════════════════════
                SettingSectionHeader { title: "  PRAYER TIMES" }

                SettingRow {
                    label: "Calculation Method"
                    sublabel: settingsRoot.backend !== null ? settingsRoot.backend.calculationMethod : "Karachi"
                    hasChevron: true
                    animDelay: 680
                    onTapped: settingsRoot.openChoice(label, "calculationMethod", settingsRoot.backend.calculationMethod)
                }
                SettingRow {
                    label: "Asr Method"
                    sublabel: settingsRoot.backend !== null ? settingsRoot.backend.asrMethod : "Hanafi"
                    hasChevron: true
                    animDelay: 740
                    onTapped: settingsRoot.openChoice(label, "asrMethod", settingsRoot.backend.asrMethod)
                }
                SettingRow {
                    label: "Location"
                    sublabel: settingsRoot.backend !== null ? settingsRoot.backend.location : "Mysuru, Karnataka, India"
                    hasChevron: true
                    animDelay: 800
                    onTapped: {
                        locationField.text = settingsRoot.backend !== null ? settingsRoot.backend.location : ""
                        locationDialog.open()
                    }
                }
                SettingRow {
                    label: "Prayer Notifications"
                    hasToggle: true
                    toggleValue: settingsRoot.prayerNotifications
                    animDelay: 860
                    onToggled: (val) => settingsRoot.setSettingBool("prayerNotifications", val)
                }
                SettingRow {
                    label: "Adhan Sound"
                    sublabel: settingsRoot.backend !== null ? settingsRoot.backend.adhanSound : "Makkah"
                    hasChevron: true
                    animDelay: 920
                    onTapped: settingsRoot.openChoice(label, "adhanSound", settingsRoot.backend.adhanSound)
                }

                Item { width: 1; height: 8 }

                // ════ LANGUAGE ═══════════════════════════════════════════
                SettingSectionHeader { title: "  LANGUAGE & REGION" }

                SettingRow {
                    label: "App Language"
                    sublabel: settingsRoot.backend !== null ? settingsRoot.backend.appLanguage : "English"
                    hasChevron: true
                    animDelay: 1000
                    onTapped: settingsRoot.openChoice(label, "appLanguage", settingsRoot.backend.appLanguage)
                }
                SettingRow {
                    label: "Hijri Calendar Offset"
                    sublabel: (settingsRoot.backend !== null ? settingsRoot.backend.hijriOffset : 0) + " days"
                    hasChevron: true
                    animDelay: 1060
                    onTapped: settingsRoot.openChoice(label, "hijriOffset", settingsRoot.backend.hijriOffset)
                }

                Item { width: 1; height: 8 }

                // ════ ABOUT ══════════════════════════════════════════════
                SettingSectionHeader { title: "  ABOUT" }

                SettingRow {
                    label: "Version"
                    sublabel: "NoorArabic v0.1.0"
                    animDelay: 1140
                }
                SettingRow {
                    label: "Licenses"
                    hasChevron: true
                    animDelay: 1200
                    onTapped: settingsStack.push("LicensesPage.qml")
                }
                SettingRow {
                    label: "Reset All Settings"
                    sublabel: "Cannot be undone"
                    hasChevron: true
                    animDelay: 1260
                    onTapped: resetDialog.open()
                }

                Item { width: 1; height: 60 }
            }
        }
    }

    // ── Reset confirmation dialog ─────────────────────────────────────────
    Dialog {
        id: resetDialog
        title: "Reset All Settings?"
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Yes | Dialog.Cancel

        background: Rectangle {
            color: "#0d1b36"; radius: 12
            border.color: "#c9a84c"; border.width: 1
        }

        header: Rectangle {
            color: "transparent"; height: 52
            Label {
                anchors.centerIn: parent
                text: "⚠️  Reset All Settings?"
                color: "#c9a84c"; font.pixelSize: 16; font.bold: true
            }
        }

        contentItem: Label {
            text: "This will reset all settings to defaults.\nThis cannot be undone."
            color: "#7a8aaa"; font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            padding: 16
        }

        onAccepted: {
            if (settingsRoot.backend !== null)
                settingsRoot.backend.resetAll()
        }
    }

    Dialog {
        id: choiceDialog
        anchors.centerIn: parent
        width: Math.min(settingsRoot.width - 32, 420)
        modal: true
        title: settingsRoot.choiceTitle

        background: Rectangle {
            color: "#0d1b36"
            radius: 12
            border.color: "#c9a84c"
            border.width: 1
        }

        header: Rectangle {
            color: "transparent"
            height: 52
            Label {
                anchors.centerIn: parent
                text: settingsRoot.choiceTitle
                color: "#c9a84c"
                font.pixelSize: 16
                font.bold: true
            }
        }

        contentItem: ListView {
            implicitHeight: Math.min(320, contentHeight)
            clip: true
            model: settingsRoot.choiceOptions

            delegate: Rectangle {
                width: ListView.view.width
                height: 48
                radius: 8
                color: modelData.value === settingsRoot.choiceCurrentValue ? "#c9a84c22" :
                       optionMouse.containsMouse ? "#1e3a6e" : "transparent"
                border.color: modelData.value === settingsRoot.choiceCurrentValue ? "#c9a84c" : "transparent"
                border.width: 1

                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: 14
                    anchors.right: selectedMark.left
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData.label
                    color: "#ffffff"
                    font.pixelSize: 14
                    elide: Text.ElideRight
                }

                Label {
                    id: selectedMark
                    anchors.right: parent.right
                    anchors.rightMargin: 14
                    anchors.verticalCenter: parent.verticalCenter
                    visible: modelData.value === settingsRoot.choiceCurrentValue
                    text: "✓"
                    color: "#c9a84c"
                    font.pixelSize: 16
                    font.bold: true
                }

                MouseArea {
                    id: optionMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        settingsRoot.setSettingString(settingsRoot.choiceKey, modelData.value)
                        choiceDialog.close()
                    }
                }
            }
        }
    }

    Dialog {
        id: locationDialog
        anchors.centerIn: parent
        width: Math.min(settingsRoot.width - 32, 440)
        modal: true
        standardButtons: Dialog.Save | Dialog.Cancel

        background: Rectangle {
            color: "#0d1b36"
            radius: 12
            border.color: "#c9a84c"
            border.width: 1
        }

        header: Rectangle {
            color: "transparent"
            height: 52
            Label {
                anchors.centerIn: parent
                text: "Prayer Location"
                color: "#c9a84c"
                font.pixelSize: 16
                font.bold: true
            }
        }

        contentItem: Column {
            spacing: 10
            padding: 16

            Label {
                width: parent.width - 32
                text: "Enter city, state, and country for prayer times."
                color: "#7a8aaa"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
            }

            TextField {
                id: locationField
                width: parent.width - 32
                placeholderText: "Mysuru, Karnataka, India"
                color: "#ffffff"
                selectedTextColor: "#1a1a2e"
                selectionColor: "#c9a84c"
                onAccepted: locationDialog.accept()
            }
        }

        onAccepted: settingsRoot.setSettingString("location", locationField.text)
    }
}
