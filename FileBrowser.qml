import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Qt.labs.folderlistmodel 2.1
import QtQuick.Controls.Material 2.0

Rectangle {
	id: browser
	property alias path: view.path
	width: parent.implicitWidth
	height: parent.implicitHeight
	color: Material.background

	GridView {
		id: view
		property string path
		anchors.left: browser.left
		anchors.leftMargin: 10
		anchors.top: browser.top
		anchors.topMargin: 10
		anchors.right: browser.right
		anchors.rightMargin: 10
		anchors.bottom: browser.bottom
        cellWidth: width / 6;
		cellHeight: 150;
		displaced: Transition {
			NumberAnimation { properties: "x,y"; duration: 1000 }
        }
		model: FolderListModel {
			id: folder
            folder: view.path
		}

		delegate: FileDelegate{
			width: view.cellWidth
			height: view.cellHeight
		}
		header: Rectangle {
			Material.background: Material.Grey
			width: browser.width
			height: 34
			z:2
			Item {
				anchors.fill: parent
				Button {
					width:32
					height :32
					text: "<<<"
					onClicked: view.path = folder.parentFolder
				}
				Text {
					text: view.path
					anchors.verticalCenter: parent.verticalCenter
					anchors.horizontalCenter: parent.horizontalCenter
				}
			}
		}
		//        footer: Rectangle {
		//            Material.background: Material.Grey
		//            width: browser.width
		//            height: 34
		//            z:2
		//            Text {
		//                text: qsTr( "Number of files : " ) + folder.count
		//                anchors.verticalCenter: parent.verticalCenter
		//                anchors.horizontalCenter: parent.horizontalCenter
		//            }
		//        }
	}
}
