import QtQuick
import QtQuick.Controls

Rectangle {
    id: licensePage
    width: Screen.width
    height: Screen.height
    color: "#1a1a2e"
    property string previewLicenseText: "NoorArabic\n\nMIT License\n\nCopyright (c) 2026 OpenNoorIlm\n\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the \"Software\"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\nSOFTWARE."
    property string licenseText: typeof appLicenseText !== "undefined" && appLicenseText !== ""
                                 ? appLicenseText : previewLicenseText

    Label {
        id: title
        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
        text: "NoorArabic License"
        color: "#c9a84c"
        font.pixelSize: 28
        font.bold: true
    }

    Button {
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.verticalCenter: title.verticalCenter
        text: "Back"
        onClicked: StackView.view.pop()
    }

    Label {
        anchors.top: title.bottom
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        text: "MIT License"
        color: "#b7c4df"
        font.pixelSize: 14
    }

    ScrollView {
        id: licenseScroll
        anchors.top: parent.top
        anchors.topMargin: 92
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 32
        clip: true

        background: Rectangle {
            color: "#0d1b36"
            radius: 10
            border.color: "#1e3a6e"
        }

        Text {
            width: licenseScroll.availableWidth - 32
            x: 16
            y: 16
            text: licensePage.licenseText
            wrapMode: Text.Wrap
            color: "#d8e2f5"
            font.pixelSize: 14
            lineHeight: 1.35
        }
    }
}
