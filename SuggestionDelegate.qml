import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

Item {
    id:delegate
    width: parent.width
    height: 25
    Column{
        anchors.fill: parent
        padding: 5
        Label {
            id: fName
            text: suggestion
            width: implicitWidth > ( delegate.width - 5 ) ? ( delegate.width - 5 ) : implicitWidth
            elide: Label.ElideRight
            color: Material.foreground
        }
        Rectangle{
            id: separator
            width: parent.width
            height: 1
            visible: true
            color: Material.accent
        }
    }

    MouseArea {
        id:mouseArea
        anchors.fill: parent
        onClicked: rootWindow.searchEngineTextChanged(suggestion)
    }
}
