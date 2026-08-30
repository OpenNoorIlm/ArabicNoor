import QtQuick
import QtQuick.Controls
import QtQuick.Timeline 1.0

Rectangle {
    id: settingsRoot
    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: "#1a1a2e"

    // ── Toggles state ─────────────────────────────────────────────────────
    property bool darkMode: true
    property bool showTafsir: false
    property bool showTranslit: true
    property bool prayerNotifications: true

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
            Keyframe { value: Math.max(16, settingsRoot.width - settingsLbl.width - 24); frame: 70 }
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

                // ════ APPEARANCE ═════════════════════════════════════════
                SettingSectionHeader { title: "  APPEARANCE" }

                SettingRow {
                    label: "Dark Mode"
                    sublabel: "Deep navy Islamic theme"
                    hasToggle: true
                    toggleValue: settingsRoot.darkMode
                    animDelay: 100
                    onToggled: (val) => settingsRoot.darkMode = val
                }
                SettingRow {
                    label: "Gold Accent Colour"
                    sublabel: "#c9a84c — Islamic gold"
                    hasChevron: true
                    animDelay: 160
                }
                SettingRow {
                    label: "Font Size"
                    sublabel: "Medium (15px)"
                    hasChevron: true
                    animDelay: 220
                }
                SettingRow {
                    label: "Arabic Font"
                    sublabel: "System default"
                    hasChevron: true
                    animDelay: 280
                }

                Item { width: 1; height: 8 }

                // ════ QURAN ══════════════════════════════════════════════
                SettingSectionHeader { title: "  QURAN" }

                SettingRow {
                    label: "Default Translation"
                    sublabel: "Kanzul Iman (Urdu)"
                    hasChevron: true
                    animDelay: 360
                }
                SettingRow {
                    label: "Show Tafsir by Default"
                    hasToggle: true
                    toggleValue: settingsRoot.showTafsir
                    animDelay: 420
                    onToggled: (val) => settingsRoot.showTafsir = val
                }
                SettingRow {
                    label: "Show Transliteration"
                    hasToggle: true
                    toggleValue: settingsRoot.showTranslit
                    animDelay: 480
                    onToggled: (val) => settingsRoot.showTranslit = val
                }
                SettingRow {
                    label: "Arabic Script"
                    sublabel: "Uthmani"
                    hasChevron: true
                    animDelay: 540
                }
                SettingRow {
                    label: "Auto-scroll Speed"
                    sublabel: "Normal"
                    hasChevron: true
                    animDelay: 600
                }

                Item { width: 1; height: 8 }

                // ════ PRAYER TIMES ═══════════════════════════════════════
                SettingSectionHeader { title: "  PRAYER TIMES" }

                SettingRow {
                    label: "Calculation Method"
                    sublabel: "Karachi (Hanafi)"
                    hasChevron: true
                    animDelay: 680
                }
                SettingRow {
                    label: "Asr Method"
                    sublabel: "Hanafi (shadow = 2×)"
                    hasChevron: true
                    animDelay: 740
                }
                SettingRow {
                    label: "Location"
                    sublabel: "Auto-detect or manual"
                    hasChevron: true
                    animDelay: 800
                }
                SettingRow {
                    label: "Prayer Notifications"
                    hasToggle: true
                    toggleValue: settingsRoot.prayerNotifications
                    animDelay: 860
                    onToggled: (val) => settingsRoot.prayerNotifications = val
                }
                SettingRow {
                    label: "Adhan Sound"
                    sublabel: "Makkah"
                    hasChevron: true
                    animDelay: 920
                }

                Item { width: 1; height: 8 }

                // ════ LANGUAGE ═══════════════════════════════════════════
                SettingSectionHeader { title: "  LANGUAGE & REGION" }

                SettingRow {
                    label: "App Language"
                    sublabel: "English"
                    hasChevron: true
                    animDelay: 1000
                }
                SettingRow {
                    label: "Hijri Calendar Offset"
                    sublabel: "0 days"
                    hasChevron: true
                    animDelay: 1060
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
            settingsRoot.darkMode = true
            settingsRoot.showTafsir = false
            settingsRoot.showTranslit = true
            settingsRoot.prayerNotifications = true
        }
    }
}
