import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasma5support 2.0 as P5Support
import org.kde.plasma.extras 2.0 as PlasmaExtras
import QtGraphicalEffects 1.0

PlasmaExtras.Representation {
        Layout.minimumHeight: row.implicitHeight
        Layout.preferredWidth: 320 * PlasmaCore.Units.devicePixelRatio
        clip: true

        id: lyricPanel
        property font currentFont: Qt.font({
            pointSize: plasmoid.configuration.tfontSize,
            weight: plasmoid.configuration.tfontWeight,
            family: plasmoid.configuration.tfont.family
        })

        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: 0
            property var slideAnimation
            Repeater {
                id: lyricNode
                model: currentLyricStr
                TextWithTime {
                    id: twi
                    texts: modelData
                    textFont: currentFont
                    unhighlightedTextColor: plasmoid.configuration.tunhighlightedColorDefault ? PlasmaCore.Theme.disabledTextColor : plasmoid.configuration.tunhighlightedColor
                    highlightedTextColor: plasmoid.configuration.thighlightedColorDefault ? PlasmaCore.Theme.highlightedTextColor : plasmoid.configuration.thighlightedColor
                }
            }
            function setclip(){
                row.anchors.centerIn=undefined
                slideAnimation = slidani.createObject(this, {
                    duration: currentTimeRange[1] ? (currentTimeRange[1] - currentTimeRange[0]) : 0,
                })
                slideAnimation.start()
            }
            function setnoclip(){
                if(slideAnimation)slideAnimation.complete()
                row.anchors.centerIn=parent
            }
        }
        
        AnimationController {
            id: controller
            SequentialAnimation {
                id: seq
            }
        }
        Component.onCompleted: {
            updateAnim()
        }
        Component {
            id: numani
            NumberAnimation {
                property: "t"
                from: 0
                to: 1
            }
        }
        Component {
            id: slidani
            NumberAnimation {
                from: 0
                to: lyricPanel.width - row.width
                target: row
                property: "x"
                easing.type: Easing.InOutCubic
                onStopped: ()=>{
                    this.destroy()
                }
            }
        }
        function updateAnim() {
            let tmp = seq.animations
            if(!currentLyricStr.length)return
            let anim = []
            for(let a = 0; a< currentLyricStr.length;a++){
                anim.push(numani.createObject(lyricPanel,{target:lyricNode.itemAt(a), duration: currentTimeList[2*a+1]-currentTimeList[2*a]}))
            }
            seq.animations = anim
            controller.progress=0
            controller.reload()
            for(let i = 0; i< tmp.length; i++)
                tmp[i].destroy()
            
            Qt.callLater(()=>{
                if (lyricPanel.width < row.width) {
                    row.setclip()
                }else {
                    row.setnoclip()
                }
            })
        }
        Connections {
            target: root
            function onCurrentItemChanged() {
                lyricPanel.updateAnim()
            }
            function onCurrentTimeChanged() {
                controller.progress = currentTimeRange[1] ? (currentTime - currentTimeRange[0]) / (currentTimeRange[1] - currentTimeRange[0]):0
            }
        }
    }