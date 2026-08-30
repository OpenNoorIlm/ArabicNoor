import QtQuick
import Lesson

Window {
    width: mainScreen.width
    height: mainScreen.height

    visible: true
    title: "Lesson"

    Screen01 {
        id: mainScreen

        anchors.centerIn: parent
    }

}

