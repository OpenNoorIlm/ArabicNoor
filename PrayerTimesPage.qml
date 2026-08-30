import QtQuick
import QtQuick.Controls
import QtQuick.Timeline 1.0

Rectangle {
    id: prayerRoot
    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: "#1a1a2e"

    property string locationText: "Mysuru, Karnataka, India"
    property bool locationSearchMode: false
    property string searchQuery: ""
    property int nextPrayerIndex: 4
    property var backend: typeof prayerTimesBackend !== "undefined" && prayerTimesBackend !== null ? prayerTimesBackend : null

    readonly property var fallbackPrayers: [
        { name: "Fajr",    arabic: "الفجر",  time: "5:12 AM",  icon: "🌙", done: true  },
        { name: "Sunrise", arabic: "الشروق", time: "6:28 AM",  icon: "🌅", done: true  },
        { name: "Dhuhr",   arabic: "الظهر",  time: "12:38 PM", icon: "☀️", done: true  },
        { name: "Asr",     arabic: "العصر",  time: "4:02 PM",  icon: "🌤️", done: true  },
        { name: "Maghrib", arabic: "المغرب", time: "6:42 PM",  icon: "🌇", done: false },
        { name: "Isha",    arabic: "العشاء", time: "8:04 PM",  icon: "🌃", done: false }
    ]
    property var prayers: backend !== null && backend.prayers.length > 0 ? backend.prayers : fallbackPrayers
    property var nextPrayer: firstUpcomingPrayer()

    Component.onCompleted: {
        console.log("PrayerTimesPage backend available:", backend !== null)
    }

    Timer {
        interval: 1
        running: prayerRoot.backend !== null
        repeat: false
        onTriggered: prayerRoot.backend.loadCity("Mysuru", "India")
    }

    function loadPrayerLocation(value) {
        var query = value.trim()
        if (query.length === 0)
            return

        prayerRoot.locationText = query
        prayerRoot.locationSearchMode = false
        prayerRoot.searchQuery = ""
        console.log("PrayerTimesPage requested location:", query, "backend:", backend !== null)
        if (backend !== null)
            backend.loadAddress(query)
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

    function backendLatitude() {
        if (backend === null || backend.latitude === "")
            return 12.2958

        return parseFloat(backend.latitude)
    }

    function backendLongitude() {
        if (backend === null || backend.longitude === "")
            return 76.6394

        return parseFloat(backend.longitude)
    }

    function backendQiblaAngle() {
        if (backend === null || backend.qiblaDirection === "")
            return 290

        return parseFloat(backend.qiblaDirection)
    }

    Connections {
        target: prayerRoot.backend
        function onLocationChanged() { prayerRoot.locationText = prayerRoot.backend.location }
        function onPrayersChanged() {
            console.log("PrayerTimesPage received prayers:", prayerRoot.backend.prayers.length)
            prayerRoot.nextPrayer = prayerRoot.firstUpcomingPrayer()
        }
    }

    // ── Heading ───────────────────────────────────────────────────────────
    Label {
        id: prayerLbl
        text: "🕌 Prayer Times"
        color: "#c9a84c"
        font.pixelSize: 28; font.bold: true; z: 2
    }

    Timeline {
        id: timeline
        animations: [ TimelineAnimation { running: true; loops: 1; to: 70; from: 0; duration: 1200 } ]
        startFrame: 0; endFrame: 70; enabled: true
        KeyframeGroup {
            target: prayerLbl; property: "x"
            Keyframe { value: prayerRoot.width * 0.5 - prayerLbl.width * 0.5; frame: 0 }
            Keyframe { value: prayerRoot.width * 0.5 - prayerLbl.width * 0.5; frame: 60 }
            Keyframe { value: Math.max(16, prayerRoot.width - prayerLbl.width - 24); frame: 70 }
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
                    Label { text: prayerRoot.backend === null ? "C++ backend unavailable" : prayerRoot.backend.error !== "" ? prayerRoot.backend.error : prayerRoot.backend.gregorianDate !== "" ? prayerRoot.backend.gregorianDate : "Loading date"; color: prayerRoot.backend !== null && prayerRoot.backend.error !== "" ? "#ff9a9a" : "#7a8aaa"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
                    Rectangle { width: 1; height: 14; color: "#c9a84c"; opacity: 0.4; anchors.verticalCenter: parent.verticalCenter }
                    Label { text: prayerRoot.backend !== null && prayerRoot.backend.hijriDate !== "" ? prayerRoot.backend.hijriDate : "Loading Hijri date"; color: "#c9a84c"; font.pixelSize: 13; font.bold: true; anchors.verticalCenter: parent.verticalCenter }
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

            // ── Offline map and Qibla card ────────────────────────────────
            Rectangle {
                width: prayerRoot.width - 32
                anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                height: 260; radius: 14
                color: "#0d1b36"
                border.color: "#c9a84c"; border.width: 1
                clip: true
                opacity: 0
                Component.onCompleted: { opacity = 1 }
                Behavior on opacity { NumberAnimation { duration: 1200; easing.type: Easing.OutCubic } }

                Canvas {
                    id: mapCanvas
                    anchors.fill: parent
                    opacity: 1.0

                    property real phase: 0
                    onPhaseChanged: requestPaint()
                    onWidthChanged: requestPaint()
                    onHeightChanged: requestPaint()

                    NumberAnimation on phase {
                        from: 0; to: Math.PI * 2
                        duration: 10000; loops: Animation.Infinite
                        running: true
                    }

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)

                        function project(lon, lat) {
                            return {
                                x: (lon + 180) / 360 * width,
                                y: (90 - lat) / 180 * height
                            }
                        }

                        function drawLand(points) {
                            if (points.length === 0)
                                return

                            var first = project(points[0][0], points[0][1])
                            ctx.beginPath()
                            ctx.moveTo(first.x, first.y)

                            for (var i = 1; i < points.length; ++i) {
                                var p = project(points[i][0], points[i][1])
                                ctx.lineTo(p.x, p.y)
                            }

                            ctx.closePath()
                            ctx.fill()
                            ctx.stroke()
                        }

                        var gradient = ctx.createLinearGradient(0, 0, width, height)
                        gradient.addColorStop(0, "#12325f")
                        gradient.addColorStop(1, "#06142a")
                        ctx.fillStyle = gradient
                        ctx.fillRect(0, 0, width, height)

                        ctx.strokeStyle = "#1f3a66"
                        ctx.lineWidth = 1
                        for (var lon = -180; lon <= 180; lon += 30) {
                            var meridianTop = project(lon, 85)
                            var meridianBottom = project(lon, -85)
                            ctx.beginPath()
                            ctx.moveTo(meridianTop.x, meridianTop.y)
                            ctx.lineTo(meridianBottom.x, meridianBottom.y)
                            ctx.stroke()
                        }

                        for (var lat = -60; lat <= 60; lat += 20) {
                            var parallelLeft = project(-180, lat)
                            var parallelRight = project(180, lat)
                            ctx.beginPath()
                            ctx.moveTo(parallelLeft.x, parallelLeft.y + Math.sin(phase + lat) * 1.5)
                            ctx.lineTo(parallelRight.x, parallelRight.y + Math.sin(phase + lat) * 1.5)
                            ctx.stroke()
                        }

                        ctx.fillStyle = "#162f42"
                        ctx.strokeStyle = "#2e5d70"
                        ctx.lineWidth = 1.2

                        drawLand([[-170, 70], [-135, 72], [-100, 55], [-82, 26], [-102, 8],
                                  [-118, 16], [-130, 48]])
                        drawLand([[-82, 12], [-48, 8], [-35, -20], [-55, -55], [-76, -48],
                                  [-80, -10]])
                        drawLand([[-20, 35], [25, 38], [50, 20], [43, -35], [18, -35],
                                  [0, 5]])
                        drawLand([[-10, 70], [45, 72], [100, 58], [145, 45], [155, 8],
                                  [105, -10], [78, 8], [45, 20], [28, 36], [-5, 35]])
                        drawLand([[110, -10], [155, -12], [150, -42], [116, -46],
                                  [104, -28]])
                        drawLand([[-52, 72], [-18, 72], [-28, 60], [-48, 60]])

                        var latitude = prayerRoot.backendLatitude()
                        var longitude = prayerRoot.backendLongitude()
                        var marker = project(longitude, latitude)
                        var kaaba = project(39.826206, 21.422487)

                        ctx.strokeStyle = "#c9a84c"
                        ctx.lineWidth = 2
                        ctx.setLineDash([7, 7])
                        ctx.beginPath()
                        ctx.moveTo(marker.x, marker.y)
                        ctx.lineTo(kaaba.x, kaaba.y)
                        ctx.stroke()
                        ctx.setLineDash([])

                        ctx.fillStyle = "#c9a84c"
                        ctx.beginPath()
                        ctx.arc(kaaba.x, kaaba.y, 5, 0, Math.PI * 2)
                        ctx.fill()

                        ctx.strokeStyle = "#c9a84c"
                        ctx.fillStyle = "#b65b2d"
                        ctx.lineWidth = 3
                        ctx.beginPath()
                        ctx.arc(marker.x, marker.y, 10 + Math.sin(phase) * 2, 0, Math.PI * 2)
                        ctx.fill()
                        ctx.stroke()

                        ctx.fillStyle = "#f8d76b"
                        ctx.font = "bold 11px sans-serif"
                        ctx.fillText("You", marker.x + 14, marker.y - 8)
                        ctx.fillText("Makkah", kaaba.x + 10, kaaba.y - 8)
                    }
                }

                Connections {
                    target: prayerRoot.backend
                    function onCoordinatesChanged() {
                        mapCanvas.requestPaint()
                    }
                }

                Rectangle {
                    id: compass
                    anchors.right: parent.right; anchors.rightMargin: 14
                    anchors.top: parent.top; anchors.topMargin: 14
                    width: 56; height: 56; radius: 28
                    color: "#071326cc"
                    border.color: "#c9a84c"
                    border.width: 1

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top; anchors.topMargin: 3
                        text: "N"
                        color: "#c9a84c"; font.pixelSize: 10; font.bold: true
                    }

                    Item {
                        anchors.centerIn: parent
                        width: 28; height: 28
                        rotation: prayerRoot.backendQiblaAngle()

                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            width: 4; height: 18; radius: 2
                            color: "#c9a84c"
                        }

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top; anchors.topMargin: -8
                            text: "▲"
                            color: "#c9a84c"; font.pixelSize: 16
                        }
                    }
                }

                Rectangle {
                    anchors.left: parent.left; anchors.leftMargin: 16
                    anchors.top: parent.top; anchors.topMargin: 16
                    width: Math.min(parent.width - 110, 360)
                    height: 76; radius: 12
                    color: "#071326dd"
                    border.color: "#c9a84c55"; border.width: 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 4

                        Label {
                            text: prayerRoot.locationText
                            color: "#c9a84c"; font.pixelSize: 15; font.bold: true
                            width: parent.width
                            elide: Text.ElideRight
                        }

                        Label {
                            text: prayerRoot.backend !== null && prayerRoot.backend.latitude !== "" ?
                                  "Lat: " + prayerRoot.backend.latitude + "  •  Lon: " + prayerRoot.backend.longitude :
                                  "Lat/Lon loading from prayer backend"
                            color: "#9badc8"; font.pixelSize: 12
                            width: parent.width
                            elide: Text.ElideRight
                        }

                        Label {
                            text: "Offline map • Qibla line to Makkah"
                            color: "#6d7f9f"; font.pixelSize: 11
                        }
                    }
                }

                Rectangle {
                    anchors.left: parent.left; anchors.leftMargin: 14
                    anchors.bottom: parent.bottom; anchors.bottomMargin: 14
                    width: qiblaRow.implicitWidth + 16; height: 28; radius: 6
                    color: "#c9a84c22"; border.color: "#c9a84c"; border.width: 1

                    Row {
                        id: qiblaRow
                        anchors.centerIn: parent; spacing: 6
                        Label { text: "🕋"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                        Label {
                            text: "Qibla: " + (prayerRoot.backend !== null && prayerRoot.backend.qiblaDirection !== "" ? prayerRoot.backend.qiblaDirection : "loading")
                            color: "#c9a84c"; font.pixelSize: 12; font.bold: true; anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                Label {
                    anchors.right: parent.right; anchors.rightMargin: 14
                    anchors.bottom: parent.bottom; anchors.bottomMargin: 14
                    text: prayerRoot.backend !== null && prayerRoot.backend.latitude !== "" ? "Location data from C++ backend" : "Waiting for C++ backend"
                    color: "#3a4a6a"; font.pixelSize: 10; font.italic: true
                }
            }

            Item { width: 1; height: 40 }
        }
    }
}
