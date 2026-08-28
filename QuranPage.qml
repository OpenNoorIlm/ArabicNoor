import QtQuick
import QtQuick.Controls
import QtQuick.Timeline 1.0
import QtQuick.Studio.DesignEffects

Rectangle {
    id: quranRoot
    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: "#1a1a2e"

    property int selectedSurah: 1
    property string selectedSurahName: "Al-Fatiha"
    property string selectedTranslation: "Kanzul Iman"
    property bool showArabic: true
    property bool showTranslation: true
    property bool showTafsir: false
    property bool showTranslit: false
    property bool surahPickerOpen: false
    property var verses: quranBackend.verses

    Component.onCompleted: quranBackend.loadSurah(selectedSurah)

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
        color: "#c9a84c"
        font.pixelSize: 28
        font.bold: true
        z: 2
        DesignEffect { effects: [ DesignDropShadow { color: "#80c9a84c" } ] }
    }

    Timeline {
        id: timeline
        animations: [ TimelineAnimation { running: true; loops: 1; to: 70; from: 0; duration: 1200 } ]
        startFrame: 0; endFrame: 70; enabled: true
        KeyframeGroup {
            target: quranLbl; property: "x"
            Keyframe { value: quranRoot.width * 0.5 - quranLbl.width * 0.5; frame: 0 }
            Keyframe { value: quranRoot.width * 0.5 - quranLbl.width * 0.5; frame: 60 }
            Keyframe { value: 883; frame: 70 }
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
        height: 52; color: "#0d1b36"; z: 2
        opacity: 0
        Component.onCompleted: { opacity = 1 }
        Behavior on opacity { NumberAnimation { duration: 600; easing.type: Easing.OutCubic } }

        Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: 1; color: "#c9a84c"; opacity: 0.2 }

        // Surah picker button
        Rectangle {
            id: surahBtn
            anchors.left: parent.left; anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            width: surahBtnLbl.implicitWidth + 32; height: 34; radius: 8
            color: quranRoot.surahPickerOpen ? "#c9a84c" : "#1e3a6e"
            border.color: "#c9a84c"; border.width: 1
            Behavior on color { ColorAnimation { duration: 200 } }
            scale: surahBtnMouse.pressed ? 0.93 : 1.0
            Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

            Row {
                anchors.centerIn: parent; spacing: 6
                Label {
                    id: surahBtnLbl
                    text: quranRoot.selectedSurah + ". " + quranRoot.selectedSurahName
                    color: quranRoot.surahPickerOpen ? "#1a1a2e" : "#c9a84c"
                    font.pixelSize: 13; font.bold: true
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
                Label {
                    text: quranRoot.surahPickerOpen ? "▲" : "▼"
                    color: quranRoot.surahPickerOpen ? "#1a1a2e" : "#c9a84c"
                    font.pixelSize: 10
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
            }
            MouseArea { id: surahBtnMouse; anchors.fill: parent; onClicked: quranRoot.surahPickerOpen = !quranRoot.surahPickerOpen }
        }

        // Translation pills
        Row {
            anchors.right: parent.right; anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            Repeater {
                model: ["Kanzul Iman", "Irfan", "Jalayn", "Uthmani"]
                delegate: Rectangle {
                    width: tLbl.implicitWidth + 14; height: 28; radius: 6
                    color: quranRoot.selectedTranslation === modelData ? "#c9a84c" : "#1e3a6e"
                    border.color: "#c9a84c"; border.width: 1
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on color { ColorAnimation { duration: 200 } }
                    scale: tMouse.pressed ? 0.92 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                    Label {
                        id: tLbl; text: modelData
                        color: quranRoot.selectedTranslation === modelData ? "#1a1a2e" : "#c9a84c"
                        font.pixelSize: 11; font.bold: true; anchors.centerIn: parent
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
        height: 38; color: "#0a1428"; z: 2

        Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: 1; color: "#c9a84c"; opacity: 0.1 }

        Row {
            anchors.left: parent.left; anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter; spacing: 8

            Repeater {
                model: [
                    { label: "ع Arabic", prop: "showArabic" },
                    { label: "TR Translation", prop: "showTranslation" },
                    { label: "TF Tafsir", prop: "showTafsir" },
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
                    color: active ? "#c9a84c22" : "transparent"
                    border.color: active ? "#c9a84c" : "#2a3a5a"; border.width: 1
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on color { ColorAnimation { duration: 200 } }
                    Label {
                        id: togLbl; text: modelData.label
                        color: active ? "#c9a84c" : "#4a5a7a"; font.pixelSize: 11; font.bold: active
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

    // ── Surah dropdown picker ─────────────────────────────────────────────
    Rectangle {
        id: surahDropdown
        anchors.top: toggleBar.bottom
        anchors.left: parent.left; anchors.right: parent.right
        height: quranRoot.surahPickerOpen ? Math.min(300, quranRoot.height * 0.4) : 0
        color: "#0d1b36"; z: 3; clip: true
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
                                quranBackend.loadSurah(quranRoot.selectedSurah)
                            }
                        }
                    }
                }
            }
        }
    }

    // ── Verse view ────────────────────────────────────────────────────────
    ScrollView {
        anchors.top: surahDropdown.bottom
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        clip: true

        Column {
            width: quranRoot.width
            spacing: 12

            // Bismillah
            Rectangle {
                width: quranRoot.width
                height: 70; color: "transparent"
                visible: quranRoot.selectedSurah !== 9

                Label {
                    anchors.centerIn: parent
                    text: "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِيمِ"
                    color: "#c9a84c"; font.pixelSize: 26; font.bold: true
                }
            }

            Repeater {
                model: quranRoot.verses.length > 0 ? quranRoot.verses : [
                    { num: 1, arabic: "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَـٰلَمِينَ", kanzul: "تمام تعریفیں اللہ کو جو رب ہے سارے جہاں کا", irfan: "All praise is due to Allah, Lord of all the worlds", jalayn: "Praise be to God, Lord of the Worlds", translit: "Alhamdu lillāhi rabb il-ʿālamīn" },
                    { num: 2, arabic: "ٱلرَّحۡمَـٰنِ ٱلرَّحِيمِ", kanzul: "بڑا مہربان نہایت رحم والا", irfan: "The Most Gracious, the Most Merciful", jalayn: "The Compassionate, the Merciful", translit: "Ar-raḥmāni r-raḥīm" },
                    { num: 3, arabic: "مَـٰلِكِ يَوۡمِ ٱلدِّينِ", kanzul: "مالک ہے روزِ جزا کا", irfan: "Master of the Day of Judgement", jalayn: "Master of the Day of Judgement", translit: "Māliki yawmi d-dīn" },
                    { num: 4, arabic: "إِيَّاكَ نَعۡبُدُ وَإِيَّاكَ نَسۡتَعِينُ", kanzul: "ہم تجھی کو پوجتے اور تجھی سے مدد مانگتے ہیں", irfan: "You alone we worship and You alone we ask for help", jalayn: "You alone we worship and You alone we ask for help", translit: "Iyyāka naʿbudu wa-iyyāka nastaʿīn" },
                    { num: 5, arabic: "ٱهۡدِنَا ٱلصِّرَٰطَ ٱلۡمُسۡتَقِيمَ", kanzul: "ہمیں سیدھی راہ چلا", irfan: "Guide us on the Straight Path", jalayn: "Guide us to the straight path", translit: "Ihdinā ṣ-ṣirāṭa l-mustaqīm" },
                    { num: 6, arabic: "صِرَٰطَ ٱلَّذِينَ أَنۡعَمۡتَ عَلَيۡهِمۡ غَيۡرِ ٱلۡمَغۡضُوبِ عَلَيۡهِمۡ وَلَا ٱلضَّآلِّينَ", kanzul: "راہ ان لوگوں کی جن پر تو نے احسان کیا، نہ ان کی جن پر غضب ہوا اور نہ بھٹکے ہوؤں کی", irfan: "The path of those You have blessed, not of those who earned anger, nor of those who went astray", jalayn: "The path of those You have blessed, not of those who earned anger, nor of those who went astray", translit: "Ṣirāṭa lladhīna anʿamta ʿalayhim ghayri l-maghḍūbi ʿalayhim wa-lā ḍ-ḍāllīn" }
                ]

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
                            NumberAnimation { target: verseCard; property: "y"; from: verseCard.y + 20; to: verseCard.y; duration: 400; easing.type: Easing.OutCubic }
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
                            text: modelData.translit; color: "#8a9abf"
                            font.pixelSize: 13; font.italic: true; wrapMode: Text.WordWrap
                        }

                        Label {
                            visible: quranRoot.showTranslation
                            width: parent.width - 32
                            text: quranRoot.selectedTranslation === "Kanzul Iman" ? modelData.kanzul :
                                  quranRoot.selectedTranslation === "Irfan" ? modelData.irfan : modelData.jalayn
                            color: "#c9a84c"; font.pixelSize: 15; wrapMode: Text.WordWrap
                            horizontalAlignment: quranRoot.selectedTranslation === "Kanzul Iman" ? Text.AlignRight : Text.AlignLeft
                        }

                        Rectangle {
                            visible: quranRoot.showTafsir
                            width: parent.width - 32
                            height: tfLbl.implicitHeight + 16
                            color: "#0a1428"; radius: 6; border.color: "#2a3a5a"; border.width: 1
                            Label {
                                id: tfLbl; anchors.fill: parent; anchors.margins: 8
                                text: "📝 Tafsir for verse " + modelData.num + " — loaded from C++ backend"
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
