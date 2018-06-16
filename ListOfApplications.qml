import QtQuick 2.6
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQml.Models 2.2
//Rectangle{
//    id:rect
//}

DelegateModel
{
    id: visualModel
    property int cellWidth: 100
    property int cellHeight: 100
    model: ListModel {
        ListElement {
            name: "YouTube"
            iconUrl : "qrc:/Images/icons/youtube.png"
            urlToLoad : "https://www.youtube.com"
        }
        ListElement {
            name: "FaceBook"
            iconUrl : "qrc:/Images/icons/facebook-logo.png"
            urlToLoad : "https://www.facebook.com/"
        }
        ListElement {
            name: "Wikipedia"
            iconUrl : "qrc:/Images/icons/Wikipedia.png"
            urlToLoad : "https://www.wikipedia.org/"
        }
        ListElement {
            name: "Google"
            iconUrl : "qrc:/Images/icons/google-logo.png"
            urlToLoad : "https://www.google.com/"
        }
    }
    delegate:Item {
        id:delegate
        Rectangle {
            id: container
            property alias imageAlias: icon
            property alias labelAlias: fName
            height: visualModel.cellHeight
            width: visualModel.cellWidth
            color: Material.background
            Image {
                id: icon
                width: container.height - 25
                height: width
                anchors.top: parent.top
                fillMode:Image.PreserveAspectFit
                source: iconUrl
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                id: fName
                anchors.top: icon.bottom
                anchors.bottom: container.bottom
                text: name
                width: implicitWidth > ( container.width - 5 ) ? ( container.width - 5 ) : implicitWidth
                elide: Label.ElideRight
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 20
            }

            MouseArea {
                id:mouseArea
                anchors.fill: parente
                hoverEnabled: true
                onClicked: {
                    console.log("Icon clicked URL : " + urlToLoad)
                    rootWindow.searchingURL = urlToLoad
                    rootWindow.reloadWebPage = true
                }
                onEntered: {
                    container.imageAlias.height = container.imageAlias.height + 20
                    container.imageAlias.width = container.imageAlias.width + 20
                    container.labelAlias.font.weight = Font.Bold
                }
                onExited:{
                    container.imageAlias.height = container.imageAlias.height - 20
                    container.imageAlias.width = container.imageAlias.width - 20
                    container.labelAlias.font.weight = Font.Normal
                }
            }
        }
    }
}
