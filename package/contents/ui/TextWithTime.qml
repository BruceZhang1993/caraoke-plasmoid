import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasma5support 2.0 as P5Support
import QtGraphicalEffects 1.0

Item{
    property string texts
    property var t
    property var unhighlightedTextColor: PlasmaCore.Theme.disabledTextColor
    property var highlightedTextColor: PlasmaCore.Theme.highlightedTextColor
    property var fontSize: 30
    property var fontWeight: Font.Normal
    property var fontFamily: "sans"
    width: mask.width
    height: mask.height
    Text {
        id: mask
        text: texts
        font.pointSize: fontSize
        font.weight: fontWeight
        font.family: fontFamily
    }
    Rectangle {
        id: bg
        anchors.top: mask.top
        anchors.bottom: mask.bottom
        anchors.left: mask.left
        anchors.right: mask.right
        color: unhighlightedTextColor
        Rectangle {
            id: left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.width*t
            color: highlightedTextColor
        }
        visible: false
    }
    
    OpacityMask {
        anchors.fill: bg
        source: bg
        maskSource: mask
    }
}