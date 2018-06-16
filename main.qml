import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import Qt.labs.folderlistmodel 2.1
import QtQuick.VirtualKeyboard 2.2
import QtQuick.Controls.Material 2.1

ApplicationWindow {
	id: window
	visible: true
	title: qsTr("SmarTv")
	Component.onCompleted: {
		window.showFullScreen()
	}

	SwipeView {
		id: swipeView
		anchors.fill: parent
		currentIndex: tabBar.currentIndex

        InbuiltApplications{
        }

		FileBrowser {
            path: "file:///home/"
		}
	}

	footer: TabBar {
		id: tabBar
		currentIndex: swipeView.currentIndex
		visible: !rootWindow.fullScreenOn

		TabButton {
			text: qsTr("In the Net")
		}
		TabButton {
			text: qsTr("Local Media")
		}
	}

    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: window.height
        width: window.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: window.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
