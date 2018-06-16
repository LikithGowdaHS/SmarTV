import QtQuick 2.0
import QtQuick.Controls.Material 2.1
import QtQuick.Controls 2.1
import QtWebEngine 1.5

Item {
    id: browser
    //	width: parent.implicitWidth
    //	height: parent.implicitHeight
    Material.theme: Material.Dark
    GridView {
        id: view
        anchors.left: browser.left
        anchors.leftMargin: 10
        anchors.top: browser.top
        anchors.right: browser.right
        anchors.rightMargin: 10
        anchors.bottom: browser.bottom
        anchors.bottomMargin: 25
        cellWidth: width / 2
        cellHeight: 400
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
        delegate: Item {
            id:delegate
            Rectangle {
                id: container
                property alias imageAlias: icon
                property alias labelAlias: fName
                height: view.cellHeight - 50
                width: view.cellWidth - 50
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
                    anchors.fill: parent
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

    WebEngineLoder{
        id: pageLoader
        anchors.fill: parent
    }
}
