import QtQuick
import QtQuick.Controls
import QtQuick.Timeline 1.0

Rectangle {
    id: quranRoot
    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: settings !== null && !settings.darkMode ? "#f4efe2" : "#1a1a2e"

    property int selectedSurah: 1
    property string selectedSurahName: "Al-Fatiha"
    property var settings: typeof settingsBackend !== "undefined" && settingsBackend !== null ? settingsBackend : null
    readonly property string accentColor: settings !== null ? settings.accentColor : "#c9a84c"
    readonly property real fontScale: settings !== null ? settings.fontScale() : 1.0
    readonly property string arabicFontFamily: settings !== null && settings.arabicFont !== "System default" ? settings.arabicFont : ""
    property string selectedTranslation: settings !== null ? settings.defaultTranslation : "Kanzul Iman"
    property bool showArabic: true
    property bool showTranslation: true
    property bool showTafsir: settings !== null ? settings.showTafsir : false
    property bool showTranslit: settings !== null ? settings.showTransliteration : false
    property bool surahPickerOpen: false
    property int pendingScrollAyah: 0
    property string gotoStatus: ""
    property var backend: typeof quranBackend !== "undefined" && quranBackend !== null ? quranBackend : null
    readonly property var fallbackVerses: [
        { num: 1, arabic: "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَـٰلَمِينَ", kanzul: "Kanzul Iman preview text loads from bundled data in the app.", irfan: "Kanzul Irfan is not present in bundled quran.db.", jalayn: "Tafsir Jalalayn preview text loads from bundled data in the app.", source: "Preview fallback" },
        { num: 2, arabic: "ٱلرَّحۡمَـٰنِ ٱلرَّحِيمِ", kanzul: "", irfan: "", jalayn: "", source: "Preview fallback" },
        { num: 3, arabic: "مَـٰلِكِ يَوۡمِ ٱلدِّينِ", kanzul: "", irfan: "", jalayn: "", source: "Preview fallback" },
        { num: 4, arabic: "إِيَّاكَ نَعۡبُدُ وَإِيَّاكَ نَسۡتَعِينُ", kanzul: "", irfan: "", jalayn: "", source: "Preview fallback" },
        { num: 5, arabic: "ٱهۡدِنَا ٱلصِّرَٰطَ ٱلۡمُسۡتَقِيمَ", kanzul: "", irfan: "", jalayn: "", source: "Preview fallback" },
        { num: 6, arabic: "صِرَٰطَ ٱلَّذِينَ أَنۡعَمۡتَ عَلَيۡهِمۡ غَيۡرِ ٱلۡمَغۡضُوبِ عَلَيۡهِمۡ وَلَا ٱلضَّآلِّينَ", kanzul: "", irfan: "", jalayn: "", source: "Preview fallback" }
    ]
    property var verses: backend !== null && backend.verses.length > 0 ? backend.verses : fallbackVerses

    readonly property var gotoTypes: [
        { label: "Surah Ayah", key: "surahAyah" },
        { label: "Quran Ayah", key: "ayah" },
        { label: "Page", key: "page" },
        { label: "Juz", key: "juz" },
        { label: "Manzil", key: "manzil" },
        { label: "Ruku", key: "ruku" },
        { label: "Hizb ¼", key: "hizbQuarter" }
    ]

    Component.onCompleted: {
        console.log("QuranPage backend available:", backend !== null)
    }

    function scaled(size) {
        return Math.round(size * fontScale)
    }

    function displayArabic(text) {
        if (settings === null || settings.arabicScript !== "Simple")
            return text

        return String(text).replace(/[\u064B-\u065F\u0670\u06D6-\u06ED]/g, "")
    }

    function autoScrollStep() {
        if (settings === null)
            return 0

        if (settings.autoScrollSpeed === "Slow")
            return 0.35
        if (settings.autoScrollSpeed === "Normal")
            return 0.7
        if (settings.autoScrollSpeed === "Fast")
            return 1.25

        return 0
    }

    Connections {
        target: quranRoot.settings
        function onSettingsChanged() {
            if (quranRoot.settings !== null) {
                quranRoot.selectedTranslation = quranRoot.settings.defaultTranslation
                quranRoot.showTafsir = quranRoot.settings.showTafsir
                quranRoot.showTranslit = quranRoot.settings.showTransliteration
            }
        }
    }

    Timer {
        interval: 50
        repeat: true
        running: quranRoot.autoScrollStep() > 0 && verseScroll.contentHeight > verseScroll.height
        onTriggered: {
            var maxY = Math.max(0, verseScroll.contentHeight - verseScroll.height)
            verseScroll.contentItem.contentY = Math.min(maxY,
                                                        verseScroll.contentItem.contentY + quranRoot.autoScrollStep())
        }
    }

    Timer {
        interval: 1
        running: quranRoot.backend !== null
        repeat: false
        onTriggered: quranRoot.backend.loadSurah(quranRoot.selectedSurah)
    }

    Connections {
        target: quranRoot.backend
        function onVersesChanged() {
            console.log("QuranPage received verses:", quranRoot.backend.verses.length)
            if (quranRoot.pendingScrollAyah > 0 && quranRoot.backend.verses.length > 0)
                quranRoot.scrollToAyah(quranRoot.pendingScrollAyah)
        }
    }

    function gotoMaximum(type) {
        if (backend === null)
            return 0
        if (type === "surahAyah")
            return backend.surahAyahMaximum(selectedSurah)
        return backend.referenceMaximum(type)
    }

    function requestGoto() {
        if (backend === null) {
            gotoStatus = "C++ backend is not available."
            return
        }

        var value = parseInt(gotoField.text)
        var type = gotoTypeBox.currentValue
        var result = backend.resolveReference(type, value, selectedSurah)

        if (!result.ok) {
            gotoStatus = result.error || "Could not find that reference."
            return
        }

        selectedSurah = result.surah
        selectedSurahName = surahNames[result.surah - 1]
        surahPickerOpen = false
        pendingScrollAyah = result.ayah
        gotoStatus = result.label
        backend.loadSurah(result.surah)
    }

    function scrollToAyah(ayah) {
        pendingScrollAyah = ayah
        scrollRetryTimer.attempts = 0
        scrollRetryTimer.restart()
    }

    Timer {
        id: scrollRetryTimer
        interval: 40
        repeat: true
        property int attempts: 0

        onTriggered: {
            attempts += 1

            var item = verseRepeater.itemAt(quranRoot.pendingScrollAyah - 1)
            if (!item || item.height <= 0 || verseColumn.height <= 0) {
                if (attempts > 30)
                    stop()
                return
            }

            var maxY = Math.max(0, verseScroll.contentHeight - verseScroll.height)
            verseScroll.contentItem.contentY = Math.min(maxY, Math.max(0, item.y - 12))

            quranRoot.pendingScrollAyah = 0
            stop()
        }
    }

    readonly property var surahNames: [
        "Al-Fatiha","Al-Baqarah","Aali Imran","An-Nisa","Al-Maidah","Al-Anam","Al-Araf","Al-Anfal",
        "At-Tawbah","Yunus","Hud","Yusuf","Ar-Rad","Ibrahim","Al-Hijr","An-Nahl","Al-Isra","Al-Kahf",
        "Maryam","Ta-Ha","Al-Anbiya","Al-Hajj","Al-Muminun","An-Nur","Al-Furqan","Ash-Shuara","An-Naml",
        "Al-Qasas","Al-Ankabut","Ar-Rum","Luqman","As-Sajdah","Al-Ahzab","Saba","Fatir","Ya-Sin",
        "As-Saffat","Sad","Az-Zumar","Ghafir","Fussilat","Ash-Shura","Az-Zukhruf","Ad-Dukhan",
        "Al-Jathiyah","Al-Ahqaf","Muhammad","Al-Fath","Al-Hujurat","Qaf","Adh-Dhariyat","At-Tur",
        "An-Najm","Al-Qamar","Ar-Rahman","Al-Waqiah","Al-Hadid","Al-Mujadila","Al-Hashr","Al-Mumtahanah",
        "As-Saf","Al-Jumuah","Al-Munafiqun","At-Taghabun","At-Talaq","At-Tahrim","Al-Mulk","Al-Qalam",
        "Al-Haqqah","Al-Maarij","Nuh","Al-Jinn","Al-Muzzammil","Al-Muddaththir","Al-Qiyamah","Al-Insan",
        "Al-Mursalat","An-Naba","An-Naziat","Abasa","At-Takwir","Al-Infitar","Al-Mutaffifin","Al-Inshiqaq",
        "Al-Buruj","At-Tariq","Al-Ala","Al-Ghashiyah","Al-Fajr","Al-Balad","Ash-Shams","Al-Layl",
        "Ad-Duha","Ash-Sharh","At-Tin","Al-Alaq","Al-Qadr","Al-Bayyinah","Az-Zalzalah","Al-Adiyat",
        "Al-Qariah","At-Takathur","Al-Asr","Al-Humazah","Al-Fil","Quraysh","Al-Maun","Al-Kawthar",
        "Al-Kafirun","An-Nasr","Al-Masad","Al-Ikhlas","Al-Falaq","An-Nas"
    ]

    // ── Heading ───────────────────────────────────────────────────────────
    Label {
        id: quranLbl
        text: "📖 Al-Quran"
        color: quranRoot.accentColor
        font.pixelSize: quranRoot.scaled(28)
        font.bold: true
        z: 2
    }

    Timeline {
        id: timeline
        animations: [ TimelineAnimation { running: true; loops: 1; to: 70; from: 0; duration: 1200 } ]
        startFrame: 0; endFrame: 70; enabled: true
        KeyframeGroup {
            target: quranLbl; property: "x"
            Keyframe { value: quranRoot.width * 0.5 - quranLbl.width * 0.5; frame: 0 }
            Keyframe { value: quranRoot.width * 0.5 - quranLbl.width * 0.5; frame: 60 }
            Keyframe { value: Math.max(16, quranRoot.width - quranLbl.width - 24); frame: 70 }
        }
        KeyframeGroup {
            target: quranLbl; property: "y"
            Keyframe { value: -quranLbl.height; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: quranRoot.height * 0.5 - quranLbl.height * 0.5; frame: 60 }
            Keyframe { value: 24; frame: 70 }
        }
        KeyframeGroup {
            target: quranLbl; property: "opacity"
            Keyframe { value: 0; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: 1; frame: 60 }
        }
    }

    // ── Toolbar ───────────────────────────────────────────────────────────
    Rectangle {
        id: toolbar
        anchors.top: parent.top; anchors.topMargin: 64
        anchors.left: parent.left; anchors.right: parent.right
        height: 52; color: settings !== null && !settings.darkMode ? "#fff8e8" : "#0d1b36"; z: 2
        opacity: 0
        Component.onCompleted: { opacity = 1 }
        Behavior on opacity { NumberAnimation { duration: 600; easing.type: Easing.OutCubic } }

        Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: 1; color: quranRoot.accentColor; opacity: 0.2 }

        // Surah picker button
        Rectangle {
            id: surahBtn
            anchors.left: parent.left; anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            width: surahBtnLbl.implicitWidth + 32; height: 34; radius: 8
            color: quranRoot.surahPickerOpen ? quranRoot.accentColor : "#1e3a6e"
            border.color: quranRoot.accentColor; border.width: 1
            Behavior on color { ColorAnimation { duration: 200 } }
            scale: surahBtnMouse.pressed ? 0.93 : 1.0
            Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

            Row {
                anchors.centerIn: parent; spacing: 6
                Label {
                    id: surahBtnLbl
                    text: quranRoot.selectedSurah + ". " + quranRoot.selectedSurahName
                    color: quranRoot.surahPickerOpen ? "#1a1a2e" : quranRoot.accentColor
                    font.pixelSize: quranRoot.scaled(13); font.bold: true
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
                Label {
                    text: quranRoot.surahPickerOpen ? "▲" : "▼"
                    color: quranRoot.surahPickerOpen ? "#1a1a2e" : quranRoot.accentColor
                    font.pixelSize: quranRoot.scaled(10)
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
            }
            MouseArea { id: surahBtnMouse; anchors.fill: parent; onClicked: quranRoot.surahPickerOpen = !quranRoot.surahPickerOpen }
        }

        // Quran text edition pills
        Row {
            anchors.right: parent.right; anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            Repeater {
                model: ["Kanzul Iman", "Kanzul Irfan", "Sahih International", "Uthmani"]
                delegate: Rectangle {
                    width: tLbl.implicitWidth + 14; height: 28; radius: 6
                    color: quranRoot.selectedTranslation === modelData ? quranRoot.accentColor : "#1e3a6e"
                    border.color: quranRoot.accentColor; border.width: 1
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on color { ColorAnimation { duration: 200 } }
                    scale: tMouse.pressed ? 0.92 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                    Label {
                        id: tLbl; text: modelData
                        color: quranRoot.selectedTranslation === modelData ? "#1a1a2e" : quranRoot.accentColor
                        font.pixelSize: quranRoot.scaled(11); font.bold: true; anchors.centerIn: parent
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    MouseArea { id: tMouse; anchors.fill: parent; onClicked: quranRoot.selectedTranslation = modelData }
                }
            }
        }
    }

    // ── Toggle bar ────────────────────────────────────────────────────────
    Rectangle {
        id: toggleBar
        anchors.top: toolbar.bottom
        anchors.left: parent.left; anchors.right: parent.right
        height: 38; color: settings !== null && !settings.darkMode ? "#f7ecd6" : "#0a1428"; z: 2

        Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: 1; color: quranRoot.accentColor; opacity: 0.1 }

        Row {
            anchors.left: parent.left; anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter; spacing: 8

            Repeater {
                model: [
                    { label: "ع Arabic", prop: "showArabic" },
                    { label: "TR Translation", prop: "showTranslation" },
                    { label: "TF Jalalayn", prop: "showTafsir" },
                    { label: "EN Translit", prop: "showTranslit" }
                ]
                delegate: Rectangle {
                    property bool active: {
                        if (modelData.prop === "showArabic") return quranRoot.showArabic
                        if (modelData.prop === "showTranslation") return quranRoot.showTranslation
                        if (modelData.prop === "showTafsir") return quranRoot.showTafsir
                        return quranRoot.showTranslit
                    }
                    width: togLbl.implicitWidth + 16; height: 26; radius: 5
                    color: active ? quranRoot.accentColor + "22" : "transparent"
                    border.color: active ? quranRoot.accentColor : "#2a3a5a"; border.width: 1
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on color { ColorAnimation { duration: 200 } }
                    Label {
                        id: togLbl; text: modelData.label
                        color: active ? quranRoot.accentColor : "#4a5a7a"; font.pixelSize: quranRoot.scaled(11); font.bold: active
                        anchors.centerIn: parent
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (modelData.prop === "showArabic") quranRoot.showArabic = !quranRoot.showArabic
                            else if (modelData.prop === "showTranslation") quranRoot.showTranslation = !quranRoot.showTranslation
                            else if (modelData.prop === "showTafsir") quranRoot.showTafsir = !quranRoot.showTafsir
                            else quranRoot.showTranslit = !quranRoot.showTranslit
                        }
                    }
                }
            }
        }
    }

    // ── Go to bar ────────────────────────────────────────────────────────
    Rectangle {
        id: gotoBar
        anchors.top: toggleBar.bottom
        anchors.left: parent.left; anchors.right: parent.right
        height: 48
        color: settings !== null && !settings.darkMode ? "#fff8e8" : "#0d1b36"
        z: 2

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: quranRoot.accentColor
            opacity: 0.12
        }

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Label {
                text: "Go to"
                color: quranRoot.accentColor
                font.pixelSize: quranRoot.scaled(12)
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }

            ComboBox {
                id: gotoTypeBox
                width: Math.min(130, quranRoot.width * 0.25)
                height: 32
                model: quranRoot.gotoTypes
                textRole: "label"
                valueRole: "key"
                anchors.verticalCenter: parent.verticalCenter
                onCurrentValueChanged: gotoField.text = ""
            }

            TextField {
                id: gotoField
                width: Math.min(86, quranRoot.width * 0.18)
                height: 32
                placeholderText: "1"
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator {
                    bottom: 1
                    top: quranRoot.gotoMaximum(gotoTypeBox.currentValue)
                }
                color: "#ffffff"
                selectedTextColor: "#1a1a2e"
                selectionColor: quranRoot.accentColor
                font.pixelSize: quranRoot.scaled(13)
                anchors.verticalCenter: parent.verticalCenter
                onAccepted: quranRoot.requestGoto()
            }

            Label {
                text: "of " + quranRoot.gotoMaximum(gotoTypeBox.currentValue)
                color: "#8a9abf"
                font.pixelSize: quranRoot.scaled(12)
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 56
                height: 32
                radius: 7
                color: goMouse.pressed ? "#b89236" : quranRoot.accentColor
                border.color: "#e0c66a"
                border.width: 1
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    text: "Go"
                    color: "#1a1a2e"
                    font.pixelSize: quranRoot.scaled(12)
                    font.bold: true
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: goMouse
                    anchors.fill: parent
                    onClicked: quranRoot.requestGoto()
                }
            }

            Label {
                width: Math.max(0, parent.width - 430)
                text: quranRoot.gotoStatus
                color: quranRoot.gotoStatus.indexOf("Enter") === 0 || quranRoot.gotoStatus.indexOf("Could") === 0 ? "#ff9a9a" : "#7a8aaa"
                font.pixelSize: quranRoot.scaled(11)
                elide: Text.ElideRight
                anchors.verticalCenter: parent.verticalCenter
                visible: width > 80
            }
        }
    }

    // ── Surah dropdown picker ─────────────────────────────────────────────
    Rectangle {
        id: surahDropdown
        anchors.top: gotoBar.bottom
        anchors.left: parent.left; anchors.right: parent.right
        height: quranRoot.surahPickerOpen ? Math.min(300, quranRoot.height * 0.4) : 0
        color: settings !== null && !settings.darkMode ? "#fff8e8" : "#0d1b36"; z: 3; clip: true
        Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: 1; color: "#c9a84c"; opacity: 0.3 }

        ScrollView {
            anchors.fill: parent; clip: true

            Grid {
                width: quranRoot.width
                columns: 4
                spacing: 0

                Repeater {
                    model: quranRoot.surahNames
                    delegate: Rectangle {
                        width: quranRoot.width / 4
                        height: 40
                        color: quranRoot.selectedSurah === index + 1 ? "#c9a84c22" : sMouse.containsMouse ? "#1e3a6e" : "transparent"
                        Behavior on color { ColorAnimation { duration: 150 } }

                        Rectangle {
                            visible: quranRoot.selectedSurah === index + 1
                            anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
                            width: 3; color: "#c9a84c"; radius: 2
                        }

                        Row {
                            anchors.left: parent.left; anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter; spacing: 6
                            Label {
                                text: (index + 1) + "."
                                color: "#c9a84c"; font.pixelSize: 11; opacity: 0.6
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Label {
                                text: modelData
                                color: quranRoot.selectedSurah === index + 1 ? "#c9a84c" : sMouse.containsMouse ? "#ffffff" : "#8a9abf"
                                font.pixelSize: 12
                                anchors.verticalCenter: parent.verticalCenter
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                        }

                        Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: 1; color: "#c9a84c"; opacity: 0.05 }

                        MouseArea {
                            id: sMouse; anchors.fill: parent; hoverEnabled: true
                            onClicked: {
                                quranRoot.selectedSurah = index + 1
                                quranRoot.selectedSurahName = modelData
                                quranRoot.surahPickerOpen = false
                                console.log("QuranPage requested surah:", quranRoot.selectedSurah, "backend:", quranRoot.backend !== null)
                                if (quranRoot.backend !== null)
                                    quranRoot.backend.loadSurah(quranRoot.selectedSurah)
                            }
                        }
                    }
                }
            }
        }
    }

    // ── Verse view ────────────────────────────────────────────────────────
    ScrollView {
        id: verseScroll
        anchors.top: surahDropdown.bottom
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        clip: true

        Column {
            id: verseColumn
            width: quranRoot.width
            spacing: 12

            Label {
                width: quranRoot.width - 32
                anchors.horizontalCenter: parent.horizontalCenter
                visible: quranRoot.backend === null || quranRoot.backend.loading || quranRoot.backend.error !== ""
                text: quranRoot.backend === null ? "C++ backend is not available in this preview." :
                      quranRoot.backend.loading ? "Loading Quran from Al Quran Cloud..." :
                      "Quran backend error: " + quranRoot.backend.error
                color: quranRoot.backend !== null && quranRoot.backend.error !== "" ? "#ff9a9a" : "#c9a84c"
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            // Bismillah
            Rectangle {
                width: quranRoot.width
                height: 70; color: "transparent"
                visible: quranRoot.selectedSurah !== 1 && quranRoot.selectedSurah !== 9

                Label {
                    anchors.centerIn: parent
                    text: "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِيمِ"
                    color: "#c9a84c"; font.pixelSize: 26; font.bold: true
                }
            }

            Repeater {
                id: verseRepeater
                model: quranRoot.verses

                delegate: Rectangle {
                    id: verseCard
                    width: quranRoot.width - 32
                    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                    height: verseCol.implicitHeight + 32
                    color: vMouse.containsMouse ? "#162447" : "#0d1b36"
                    radius: 10
                    border.color: vMouse.containsMouse ? "#c9a84c" : "#1e3a6e"; border.width: 1
                    opacity: 0
                    Behavior on color { ColorAnimation { duration: 200 } }
                    Behavior on border.color { ColorAnimation { duration: 200 } }

                    Component.onCompleted: vAnim.start()
                    SequentialAnimation {
                        id: vAnim
                        PauseAnimation { duration: index * 80 }
                        ParallelAnimation {
                            NumberAnimation { target: verseCard; property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic }
                        }
                    }

                    Column {
                        id: verseCol
                        anchors.left: parent.left; anchors.right: parent.right
                        anchors.top: parent.top; anchors.margins: 16; spacing: 12

                        Rectangle {
                            width: 32; height: 32; radius: 16
                            color: "#c9a84c22"; border.color: "#c9a84c"; border.width: 1
                            Label { text: modelData.num; color: "#c9a84c"; font.pixelSize: 13; font.bold: true; anchors.centerIn: parent }
                        }

                        Label {
                            visible: quranRoot.showArabic
                            width: parent.width - 32
                            text: modelData.arabic; color: "#ffffff"
                            font.pixelSize: 26; horizontalAlignment: Text.AlignRight
                            wrapMode: Text.WordWrap
                        }

                        Label {
                            visible: quranRoot.showTranslit
                            width: parent.width - 32
                            text: modelData.translit || ""; color: "#8a9abf"
                            font.pixelSize: 13; font.italic: true; wrapMode: Text.WordWrap
                        }

                        Label {
                            visible: quranRoot.showTranslation
                            width: parent.width - 32
                            text: quranRoot.selectedTranslation === "Kanzul Iman" ? (modelData.kanzul || "Kanzul Iman is not present for this verse.") :
                                  quranRoot.selectedTranslation === "Kanzul Irfan" ? (modelData.irfan || "Kanzul Irfan is not present in bundled quran.db.") :
                                  quranRoot.selectedTranslation === "Sahih International" ? (modelData.sahih || "Sahih International is not present for this verse.") :
                                  "Source: " + modelData.source + " / Uthmani"
                            color: "#c9a84c"; font.pixelSize: 15; wrapMode: Text.WordWrap
                            horizontalAlignment: quranRoot.selectedTranslation === "Uthmani" ? Text.AlignLeft : Text.AlignRight
                        }

                        Rectangle {
                            visible: quranRoot.showTafsir
                            width: parent.width - 32
                            height: Math.max(44, tfLbl.implicitHeight + 16)
                            color: "#0a1428"; radius: 6; border.color: "#2a3a5a"; border.width: 1
                            Label {
                                id: tfLbl; anchors.fill: parent; anchors.margins: 8
                                text: modelData.jalayn || "Tafsir Jalalayn is not present for this verse."
                                color: "#7a8aaa"; font.pixelSize: 13; wrapMode: Text.WordWrap
                            }
                        }
                    }

                    MouseArea { id: vMouse; anchors.fill: parent; hoverEnabled: true }
                }
            }

            Item { width: 1; height: 40 }
        }
    }
}
