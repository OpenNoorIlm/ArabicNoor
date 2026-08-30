

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import Lesson
import QtQuick3D
import QtQuick3D.AssetUtils
import QtQuick3D.Effects
import QtQuick3D.Helpers
import QtQuick3D.Particles3D
import QtQuick3D.Physics
import QtQuick3D.Physics.Helpers
import QtQuick3D.SpatialAudio
import QtQuick3D.Xr

Rectangle {
    id: rectangle
    width: Constants.width
    height: Constants.height
    color: "#000000"

    Item {
        id: __materialLibrary__

        PrincipledMaterial {
            id: principledMaterial
            lightProbe: color_table
            objectName: "New Material"
        }

        Texture {
            id: color_table
            source: "color_table.png"
            objectName: "Color table"
        }

        PrincipledMaterial {
            id: newMaterial
            baseColor: "#d21212"
            objectName: "New Material"
        }
    }
}



