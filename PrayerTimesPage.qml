import QtQuick
import QtQuick.Controls
import QtQuick.Timeline 1.0
import QtQuick.Studio.DesignEffects

Rectangle {
    id: prayerRoot
    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: "#1a1a2e"

    property string locationText: "Mysuru, Karnataka, IN"
    property bool locationSearchMode: false
    property string searchQuery: ""
    property int nextPrayerIndex: 4
    property var nextPrayer: firstUpcomingPrayer()

    property var prayers: prayerTimesBackend.prayers.length > 0 ? prayerTimesBackend.prayers : [
        { name: "Fajr",    arabic: "الفجر",  time: "5:12 AM",  icon: "🌙", done: true  },
        { name: "Sunrise", arabic: "الشروق", time: "6:28 AM",  icon: "🌅", done: true  },
        { name: "Dhuhr",   arabic: "الظهر",  time: "12:38 PM", icon: "☀️", done: true  },
        { name: "Asr",     arabic: "العصر",  time: "4:02 PM",  icon: "🌤️", done: true  },
        { name: "Maghrib", arabic: "المغرب", time: "6:42 PM",  icon: "🌇", done: false },
        { name: "Isha",    arabic: "العشاء", time: "8:04 PM",  icon: "🌃", done: false }
    ]

    Component.onCompleted: prayerTimesBackend.loadCity("Mysuru", "India")

    function loadPrayerLocation(value) {
        var query = value.trim()
        if (query.length === 0)
            return

        prayerRoot.locationText = query
        prayerRoot.locationSearchMode = false
        prayerRoot.searchQuery = ""
        prayerTimesBackend.loadAddress(query)
    }

    function firstUpcomingPrayer() {
        for (var i = 0; i < prayerRoot.prayers.length; ++i) {
            if (!prayerRoot.prayers[i].done)
                return prayerRoot.prayers[i]
        }
        return prayerRoot.prayers.length > 0 ? prayerRoot.prayers[0] : { name: "", time: "", icon: "" }
    }

    function prayerIcon(name) {
        if (name === "moon")
            return "🌙"
        if (name === "sunrise")
            return "🌅"
        if (name === "sun")
            return "☀"
        if (name === "cloud-sun")
            return "☀"
        if (name === "sunset")
            return "🌇"
        if (name === "night")
            return "🌃"
        return name
    }

    Connections {
        target: prayerTimesBackend
        function onLocationChanged() { prayerRoot.locationText = prayerTimesBackend.location }
        function onPrayersChanged() { prayerRoot.nextPrayer = prayerRoot.firstUpcomingPrayer() }
    }

    // ── Heading ───────────────────────────────────────────────────────────
    Label {
        id: prayerLbl
        text: "🕌 Prayer Times"
        color: "#c9a84c"
        font.pixelSize: 28; font.bold: true; z: 2
        DesignEffect { effects: [ DesignDropShadow { color: "#80c9a84c" } ] }
    }

    Timeline {
        id: timeline
        animations: [ TimelineAnimation { running: true; loops: 1; to: 70; from: 0; duration: 1200 } ]
        startFrame: 0; endFrame: 70; enabled: true
        KeyframeGroup {
            target: prayerLbl; property: "x"
            Keyframe { value: prayerRoot.width * 0.5 - prayerLbl.width * 0.5; frame: 0 }
            Keyframe { value: prayerRoot.width * 0.5 - prayerLbl.width * 0.5; frame: 60 }
            Keyframe { value: 883; frame: 70 }
        }
        KeyframeGroup {
            target: prayerLbl; property: "y"
            Keyframe { value: -prayerLbl.height; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: prayerRoot.height * 0.5 - prayerLbl.height * 0.5; frame: 60 }
            Keyframe { value: 24; frame: 70 }
        }
        KeyframeGroup {
            target: prayerLbl; property: "opacity"
            Keyframe { value: 0; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: 1; frame: 60 }
        }
    }

    ScrollView {
        anchors.top: parent.top; anchors.topMargin: 70
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        clip: true

        Column {
            width: prayerRoot.width
            spacing: 12

            // ── Location bar ─────────────────────────────────────────────
            Rectangle {
                width: prayerRoot.width
                height: 60; color: "#0d1b36"
                opacity: 0
                Component.onCompleted: { opacity = 1 }
                Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }

                Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: 1; color: "#c9a84c"; opacity: 0.2 }

                Row {
                    anchors.left: parent.left; anchors.leftMargin: 16
                    anchors.right: parent.right; anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter; spacing: 8

                    Label { text: "📍"; font.pixelSize: 18; anchors.verticalCenter: parent.verticalCenter }

                    Rectangle {
                        width: parent.width - 100; height: 34; radius: 8
                        color: prayerRoot.locationSearchMode ? "#1e3a6e" : "#0a1428"
                        border.color: prayerRoot.locationSearchMode ? "#c9a84c" : "#2a3a5a"; border.width: 1
                        Behavior on color { ColorAnimation { duration: 200 } }
                        Behavior on border.color { ColorAnimation { duration: 200 } }

                        TextInput {
                            id: locationInput
                            anchors.fill: parent; anchors.margins: 8
                            visible: prayerRoot.locationSearchMode
                            color: "#c9a84c"; font.pixelSize: 14
                            onTextChanged: prayerRoot.searchQuery = text
                            Keys.onReturnPressed: {
                                prayerRoot.loadPrayerLocation(text)
                            }
                        }
                        Label {
                            anchors.fill: parent; anchors.margins: 8
                            visible: !prayerRoot.locationSearchMode
                            text: prayerRoot.locationText
                            color: "#c9a84c"; font.pixelSize: 14; elide: Text.ElideRight
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                prayerRoot.locationSearchMode = true
                                locationInput.text = ""
                                locationInput.forceActiveFocus()
                            }
                        }
                    }

                    // Search button
                    Rectangle {
                        width: 34; height: 34; radius: 8
                        color: sb1.containsMouse ? "#c9a84c" : "#1e3a6e"
                        border.color: "#c9a84c"; border.width: 1
                        Behavior on color { ColorAnimation { duration: 200 } }
                        scale: sb1.pressed ? 0.9 : 1.0
                        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                        Label { text: "🔍"; font.pixelSize: 15; anchors.centerIn: parent }
                        MouseArea {
                            id: sb1; anchors.fill: parent; hoverEnabled: true
                            onClicked: {
                                prayerRoot.loadPrayerLocation(locationInput.text)
                            }
                        }
                    }

                    // GPS button
                    Rectangle {
                        width: 34; height: 34; radius: 8
                        color: sb2.containsMouse ? "#c9a84c" : "#1e3a6e"
                        border.color: "#c9a84c"; border.width: 1
                        Behavior on color { ColorAnimation { duration: 200 } }
                        scale: sb2.pressed ? 0.9 : 1.0
                        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                        Label { text: "🎯"; font.pixelSize: 15; anchors.centerIn: parent }
                        MouseArea {
                            id: sb2; anchors.fill: parent; hoverEnabled: true
                            onClicked: {
                                prayerRoot.loadPrayerLocation("Mysuru, Karnataka, India")
                                prayerRoot.locationSearchMode = false
                            }
                        }
                    }
                }
            }

            // ── Search suggestions ────────────────────────────────────────
            Rectangle {
                width: prayerRoot.width
                height: prayerRoot.locationSearchMode && prayerRoot.searchQuery.length > 1 ? suggCol.implicitHeight : 0
                color: "#0a1428"; clip: true
                Behavior on height { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

                Column {
                    id: suggCol
                    width: parent.width

                    Repeater {
                        model: ["Mysuru, Karnataka, India", "Makkah, Saudi Arabia", "Madinah, Saudi Arabia", "Karachi, Pakistan", "Istanbul, Turkey", "Cairo, Egypt", "Lahore, Pakistan", "Dubai, UAE"]
                        delegate: Rectangle {
                            width: prayerRoot.width; height: 40
                            color: sm.containsMouse ? "#1e3a6e" : "transparent"
                            Behavior on color { ColorAnimation { duration: 150 } }
                            Label {
                                text: "📍  " + modelData; color: "#c9a84c"; font.pixelSize: 14
                                anchors.left: parent.left; anchors.leftMargin: 20; anchors.verticalCenter: parent.verticalCenter
                            }
                            Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: 1; color: "#c9a84c"; opacity: 0.08 }
                            MouseArea {
                                id: sm; anchors.fill: parent; hoverEnabled: true
                                onClicked: { prayerRoot.loadPrayerLocation(modelData) }
                            }
                        }
                    }
                }
            }

            // ── Date & Hijri ──────────────────────────────────────────────
            Rectangle {
                width: prayerRoot.width; height: 44; color: "transparent"
                opacity: 0
                Component.onCompleted: { opacity = 1 }
                Behavior on opacity { NumberAnimation { duration: 700; easing.type: Easing.OutCubic } }

                Row {
                    anchors.centerIn: parent; spacing: 16
                    Label { text: prayerTimesBackend.gregorianDate !== "" ? prayerTimesBackend.gregorianDate : "Loading date"; color: "#7a8aaa"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                    Rectangle { width: 1; height: 14; color: "#c9a84c"; opacity: 0.4; anchors.verticalCenter: parent.verticalCenter }
                    Label { text: prayerTimesBackend.hijriDate !== "" ? prayerTimesBackend.hijriDate : "Loading Hijri date"; color: "#c9a84c"; font.pixelSize: 13; font.bold: true; anchors.verticalCenter: parent.verticalCenter }
                }
            }

            // ── Next prayer banner ────────────────────────────────────────
            Rectangle {
                width: prayerRoot.width - 32
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                height: 76; radius: 12
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#0d1b36" }
                    GradientStop { position: 0.5; color: "#1e3a6e" }
                    GradientStop { position: 1.0; color: "#0d1b36" }
                }
                border.color: "#c9a84c"; border.width: 1
                opacity: 0
                Component.onCompleted: { opacity = 1 }
                Behavior on opacity { NumberAnimation { duration: 900; easing.type: Easing.OutCubic } }

                SequentialAnimation on border.width {
                    running: true; loops: Animation.Infinite
                    NumberAnimation { from: 1; to: 2; duration: 1000; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 2; to: 1; duration: 1000; easing.type: Easing.InOutSine }
                }

                Row {
                    anchors.centerIn: parent; spacing: 24

                    Column {
                        anchors.verticalCenter: parent.verticalCenter; spacing: 2
                        Label { text: "Next Prayer"; color: "#7a8aaa"; font.pixelSize: 11 }
                        Label { text: prayerRoot.nextPrayer.name + "  " + prayerRoot.prayerIcon(prayerRoot.nextPrayer.icon); color: "#ffffff"; font.pixelSize: 20; font.bold: true }
                    }
                    Rectangle { width: 1; height: 36; color: "#c9a84c"; opacity: 0.4; anchors.verticalCenter: parent.verticalCenter }
                    Column {
                        anchors.verticalCenter: parent.verticalCenter; spacing: 2
                        Label { text: "Iqama"; color: "#7a8aaa"; font.pixelSize: 11 }
                        Label { text: prayerRoot.nextPrayer.time; color: "#c9a84c"; font.pixelSize: 20; font.bold: true }
                    }
                    Rectangle { width: 1; height: 36; color: "#c9a84c"; opacity: 0.4; anchors.verticalCenter: parent.verticalCenter }
                    Column {
                        anchors.verticalCenter: parent.verticalCenter; spacing: 2
                        Label { text: "Remaining"; color: "#7a8aaa"; font.pixelSize: 11 }
                        Label {
                            id: countdown
                            property int secs: 5040
                            text: Math.floor(secs / 3600) + "h " + Math.floor((secs % 3600) / 60) + "m " + (secs % 60) + "s"
                            color: "#c9a84c"; font.pixelSize: 20; font.bold: true
                            Timer {
                                interval: 1000; running: true; repeat: true
                                onTriggered: if (countdown.secs > 0) countdown.secs--
                            }
                        }
                    }
                }
            }

            // ── Prayer cards ──────────────────────────────────────────────
            Repeater {
                model: prayerRoot.prayers

                delegate: Rectangle {
                    id: pCard
                    width: prayerRoot.width - 32
                    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                    height: 60; radius: 10
                    color: pcMouse.containsMouse ? (modelData.done ? "#0f2040" : "#1e3a6e") : (modelData.done ? "#0a1428" : "#162447")
                    border.color: modelData.done ? "#1e2a40" : "#c9a84c"
                    border.width: modelData.done ? 1 : 2
                    opacity: 0
                    Behavior on color { ColorAnimation { duration: 200 } }

                    Component.onCompleted: pcAnim.start()
                    SequentialAnimation {
                        id: pcAnim
                        PauseAnimation { duration: index * 90 }
                        ParallelAnimation {
                            NumberAnimation { target: pCard; property: "opacity"; from: 0; to: 1; duration: 450; easing.type: Easing.OutCubic }
                            NumberAnimation { target: pCard; property: "x"; from: -40; to: 0; duration: 450; easing.type: Easing.OutCubic }
                        }
                    }

                    // Pulse on next prayer
                    SequentialAnimation on border.width {
                        running: !modelData.done
                        loops: Animation.Infinite
                        NumberAnimation { from: 2; to: 3; duration: 900; easing.type: Easing.InOutSine }
                        NumberAnimation { from: 3; to: 2; duration: 900; easing.type: Easing.InOutSine }
                    }

                    // Completed checkmark glow bar on left
                    Rectangle {
                        anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
                        width: 4; radius: 2
                        color: modelData.done ? "#2a3a5a" : "#c9a84c"
                        SequentialAnimation on opacity {
                            running: !modelData.done
                            loops: Animation.Infinite
                            NumberAnimation { from: 1.0; to: 0.4; duration: 900; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 0.4; to: 1.0; duration: 900; easing.type: Easing.InOutSine }
                        }
                    }

                    Row {
                        anchors.left: parent.left; anchors.leftMargin: 16
                        anchors.right: parent.right; anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter; spacing: 0

                        Label { text: prayerRoot.prayerIcon(modelData.icon); font.pixelSize: 20; width: 36; anchors.verticalCenter: parent.verticalCenter }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter; spacing: 1
                            Label {
                                text: modelData.name
                                color: modelData.done ? "#4a5a7a" : "#ffffff"
                                font.pixelSize: 15; font.bold: !modelData.done
                            }
                            Label {
                                text: modelData.arabic
                                color: modelData.done ? "#3a4a6a" : "#c9a84c"
                                font.pixelSize: 12
                            }
                        }

                        Item { width: pCard.width - 260 }

                        Label {
                            text: modelData.time
                            color: modelData.done ? "#4a5a7a" : "#c9a84c"
                            font.pixelSize: 17; font.bold: !modelData.done
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Label {
                            visible: modelData.done
                            text: "  ✓"
                            color: "#2a5a2a"; font.pixelSize: 16; font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea { id: pcMouse; anchors.fill: parent; hoverEnabled: true }
                }
            }

            // ── Location visual card (Islamic geometric) ──────────────────
            Rectangle {
                width: prayerRoot.width - 32
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                height: 220; radius: 14
                color: "#0d1b36"
                border.color: "#c9a84c"; border.width: 1
                clip: true
                opacity: 0
                Component.onCompleted: { opacity = 1 }
                Behavior on opacity { NumberAnimation { duration: 1200; easing.type: Easing.OutCubic } }

                // Islamic geometric background pattern (animated)
                Canvas {
                    id: geoCanvas
                    anchors.fill: parent
                    opacity: 0.18

                    property real phase: 0
                    onPhaseChanged: requestPaint()

                    NumberAnimation on phase {
                        from: 0; to: Math.PI * 2
                        duration: 8000; loops: Animation.Infinite
                        running: true
                    }

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.strokeStyle = "#c9a84c"
                        ctx.lineWidth = 0.8

                        var step = 40
                        for (var x = 0; x < width + step; x += step) {
                            for (var y = 0; y < height + step; y += step) {
                                var r = step * 0.4 + Math.sin(phase + x * 0.05 + y * 0.03) * 4
                                ctx.beginPath()
                                ctx.arc(x, y, r, 0, Math.PI * 2)
                                ctx.stroke()

                                ctx.beginPath()
                                ctx.moveTo(x - step * 0.5, y)
                                ctx.lineTo(x + step * 0.5, y)
                                ctx.moveTo(x, y - step * 0.5)
                                ctx.lineTo(x, y + step * 0.5)
                                ctx.stroke()
                            }
                        }
                    }
                }

                // Glowing center pin
                Column {
                    anchors.centerIn: parent; spacing: 4

                    Rectangle {
                        width: 60; height: 60; radius: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#c9a84c22"
                        border.color: "#c9a84c"; border.width: 2

                        SequentialAnimation on scale {
                            running: true; loops: Animation.Infinite
                            NumberAnimation { from: 1.0; to: 1.15; duration: 1200; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 1.15; to: 1.0; duration: 1200; easing.type: Easing.InOutSine }
                        }

                        SequentialAnimation on border.width {
                            running: true; loops: Animation.Infinite
                            NumberAnimation { from: 2; to: 4; duration: 1200; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 4; to: 2; duration: 1200; easing.type: Easing.InOutSine }
                        }

                        Label { text: "📍"; font.pixelSize: 28; anchors.centerIn: parent }
                    }

                    Label {
                        text: prayerRoot.locationText
                        color: "#c9a84c"; font.pixelSize: 15; font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Label {
                        text: "Lat: 12.2958° N  •  Lon: 76.6394° E"
                        color: "#7a8aaa"; font.pixelSize: 12
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // Compass rose
                Label {
                    anchors.right: parent.right; anchors.rightMargin: 14
                    anchors.top: parent.top; anchors.topMargin: 14
                    text: "N\n⬆"
                    color: "#c9a84c"; font.pixelSize: 11; font.bold: true
                    horizontalAlignment: Text.AlignHCenter

                    SequentialAnimation on opacity {
                        running: true; loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 0.4; duration: 2000; easing.type: Easing.InOutSine }
                        NumberAnimation { from: 0.4; to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
                    }
                }

                // Qibla direction indicator
                Rectangle {
                    anchors.left: parent.left; anchors.leftMargin: 14
                    anchors.bottom: parent.bottom; anchors.bottomMargin: 14
                    width: qiblaRow.implicitWidth + 16; height: 28; radius: 6
                    color: "#c9a84c22"; border.color: "#c9a84c"; border.width: 1

                    Row {
                        id: qiblaRow
                        anchors.centerIn: parent; spacing: 6
                        Label { text: "🕋"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                        Label { text: "Qibla: 292°"; color: "#c9a84c"; font.pixelSize: 12; font.bold: true; anchors.verticalCenter: parent.verticalCenter }
                    }
                }

                Label {
                    anchors.right: parent.right; anchors.rightMargin: 14
                    anchors.bottom: parent.bottom; anchors.bottomMargin: 14
                    text: "Full map via C++ backend"
                    color: "#3a4a6a"; font.pixelSize: 10; font.italic: true
                }
            }

            Item { width: 1; height: 40 }
        }
    }
}
