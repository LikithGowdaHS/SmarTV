import QtQuick 2.0
import QtWebEngine 1.5
import QtQuick.Window 2.2
import Qt.labs.settings 1.0
import QtQml 2.2
import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0 as QQCPrivate
import QtQuick.Controls.Styles 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0

Rectangle {
	id: browserWindow
	signal closeWebBrowser()
	property QtObject applicationRoot
	property Item currentWebView: tabs.currentIndex < tabs.count ? tabs.getTab(tabs.currentIndex).item : null
	visible: rootWindow.reloadWebPage

	property QtObject defaultProfile: WebEngineProfile {
		storageName: "Default"
	}

	property QtObject otrProfile: WebEngineProfile {
		offTheRecord: true
	}

	property Component browserWindowComponent: BrowserWindow {
		applicationRoot: root
		onClosing: destroy()
	}
	property Component browserDialogComponent: BrowserDialog {
//		onClosing: destroy()
	}

	function createWindow(profile) {
		var newWindow = browserWindowComponent.createObject(root);
		newWindow.currentWebView.profile = profile;
		profile.downloadRequested.connect(newWindow.onDownloadRequested);
		return newWindow;
	}
	function createDialog(profile) {
		var newDialog = browserDialogComponent.createObject(root);
		newDialog.currentWebView.profile = profile;
		return newDialog;
	}
	function load(url) {
		var browserWindow = createWindow(defaultProfile);
		browserWindow.currentWebView.url = url;
	}

	Action {
		shortcut: "Ctrl+D"
		onTriggered: {
			downloadView.visible = !downloadView.visible;
		}
	}
	Action {
		id: focus
		shortcut: "Ctrl+L"
		onTriggered: {
			addressBar.forceActiveFocus();
			addressBar.selectAll();
		}
	}
	Action {
		shortcut: StandardKey.Refresh
		onTriggered: {
			if (currentWebView)
				currentWebView.reload();
		}
	}
	Action {
		shortcut: StandardKey.AddTab
		onTriggered: {
			tabs.createEmptyTab(currentWebView.profile);
			tabs.currentIndex = tabs.count - 1;
			addressBar.forceActiveFocus();
			addressBar.selectAll();
		}
	}
	Action {
		shortcut: StandardKey.Close
		onTriggered: {
			currentWebView.triggerWebAction(WebEngineView.RequestClose);
		}
	}
	Action {
		shortcut: "Escape"
		onTriggered: {
			if (currentWebView.state === "FullScreen")
			{
				fullScreenNotification.hide();
				currentWebView.state = "normalScreen"
				currentWebView.triggerWebAction(WebEngineView.ExitFullScreen);
			}
		}
	}
	Action {
		shortcut: "Ctrl+0"
		onTriggered: currentWebView.zoomFactor = 1.0
	}
	Action {
		shortcut: StandardKey.ZoomOut
		onTriggered: currentWebView.zoomFactor -= 0.1
	}
	Action {
		shortcut: StandardKey.ZoomIn
		onTriggered: currentWebView.zoomFactor += 0.1
	}

	Action {
		shortcut: StandardKey.Copy
		onTriggered: currentWebView.triggerWebAction(WebEngineView.Copy)
	}
	Action {
		shortcut: StandardKey.Cut
		onTriggered: currentWebView.triggerWebAction(WebEngineView.Cut)
	}
	Action {
		shortcut: StandardKey.Paste
		onTriggered: currentWebView.triggerWebAction(WebEngineView.Paste)
	}
	Action {
		shortcut: "Shift+"+StandardKey.Paste
		onTriggered: currentWebView.triggerWebAction(WebEngineView.PasteAndMatchStyle)
	}
	Action {
		shortcut: StandardKey.SelectAll
		onTriggered: currentWebView.triggerWebAction(WebEngineView.SelectAll)
	}
	Action {
		shortcut: StandardKey.Undo
		onTriggered: currentWebView.triggerWebAction(WebEngineView.Undo)
	}
	Action {
		shortcut: StandardKey.Redo
		onTriggered: currentWebView.triggerWebAction(WebEngineView.Redo)
	}
	Action {
		shortcut: StandardKey.Back
		onTriggered: currentWebView.triggerWebAction(WebEngineView.Back)
	}
	Action {
		shortcut: StandardKey.Forward
		onTriggered: currentWebView.triggerWebAction(WebEngineView.Forward)
	}

	onCloseWebBrowser: {
		rootWindow.searchingURL = ""
		var tabCount = tabs.count
		for (var i = 0; i < tabCount; ++i)
		{
			tabs.removeTab(i)
		}
		if( tabs.count == 0 )
		{
			tabs.createEmptyTab(defaultProfile)
			rootWindow.reloadWebPage = false
		}
	}
	ToolBar {
		id: navigationBar
		anchors.top: parent.top
		anchors.topMargin: 5
		signal closeWebBrowser()

		onCloseWebBrowser: parent.closeWebBrowser()
		RowLayout {
			anchors.fill: parent
			signal closeWebBrowser()
			ToolButton {
				enabled: currentWebView && (currentWebView.canGoBack || currentWebView.canGoForward)
				menu:Menu {
					id: historyMenu

					Instantiator {
						model: currentWebView && currentWebView.navigationHistory.items
						MenuItem {
							text: model.title
							onTriggered: currentWebView.goBackOrForward(model.offset)
							checkable: !enabled
							checked: !enabled
							enabled: model.offset
						}

						onObjectAdded: historyMenu.insertItem(index, object)
						onObjectRemoved: historyMenu.removeItem(object)
					}
				}
			}
			onCloseWebBrowser: navigationBar.closeWebBrowser()

			ToolButton {
				id: backButton
				iconSource: "qrc:/Images/icons/go-previous.png"
				onClicked: currentWebView.goBack()
				enabled: currentWebView && currentWebView.canGoBack
				activeFocusOnTab: true
			}
			ToolButton {
				id: forwardButton
				iconSource: "qrc:/Images/icons/go-next.png"
				onClicked: currentWebView.goForward()
				enabled: currentWebView && currentWebView.canGoForward
				activeFocusOnTab:true
			}
			ToolButton {
				id: reloadButton
				iconSource: currentWebView && currentWebView.loading ? "qrc:/Images/icons/process-stop.png" : "qrc:/Images/icons/view-refresh.png"
				onClicked: currentWebView && currentWebView.loading ? currentWebView.stop() : currentWebView.reload()
				activeFocusOnTab: true
			}
			ToolButton {
				id: closeButton
				iconSource: "qrc:/Images/icons/close.png"
				onClicked: parent.closeWebBrowser()
				activeFocusOnTab: true
			}
			TextField {
				id: addressBar
				Image {
					anchors.verticalCenter: addressBar.verticalCenter;
					x: 5
					z: 2
					id: faviconImage
					width: 16; height: 16
					sourceSize: Qt.size(width, height)
					source: currentWebView && currentWebView.icon
				}
				style: TextFieldStyle {
					padding {
						left: 26;
					}
				}
				focus: true
				Layout.fillWidth: true
				text: currentWebView && currentWebView.url
				onAccepted: currentWebView.url = rootWindow.fromUserInput(text)
			}
		}

		ProgressBar {
			id: progressBar
			height: 3
			anchors {
				left: parent.left
				top: parent.bottom
				right: parent.right
				leftMargin: -parent.leftMargin
				rightMargin: -parent.rightMargin
			}
			style: ProgressBarStyle {
				background: Item {}
			}
			z: -2;
			minimumValue: 0
			maximumValue: 100
			value: (currentWebView && currentWebView.loadProgress < 100) ? currentWebView.loadProgress : 0
		}
	}
	TabView {
		id: tabs
		anchors.top: navigationBar.bottom
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		function createEmptyTab(profile) {
			var tab = addTab("", tabComponent);
			// We must do this first to make sure that tab.active gets set so that tab.item gets instantiated immediately.
			tab.active = true;
			tab.title = Qt.binding(function() { return tab.item.title });
			tab.item.profile = profile;
			return tab;
		}
		Component.onCompleted: createEmptyTab(defaultProfile)

		Component {
			id: tabComponent
			WebEngineView {
				id: webEngineView
				focus: true
				url:{
					console.log(" search url is  :  " + rootWindow.searchingURL);
					return rootWindow.searchingURL
				}

				onLinkHovered: {
					if (hoveredUrl == "")
						resetStatusText.start();
					else {
						resetStatusText.stop();
						statusText.text = hoveredUrl;
					}
				}

				states: [
					State {
						name: "FullScreen"
						PropertyChanges {
							target: tabs
							frameVisible: false
							tabsVisible: false
							anchors.top: browserWindow.top
							anchors.bottom: browserWindow.bottom
							anchors.left: browserWindow.left
							anchors.right: browserWindow.right
						}
						PropertyChanges {
							target: navigationBar
							visible: false
						}
					},
					State {
						name: "normalScreen"
						PropertyChanges {
							target: navigationBar
							visible: true
						}
						PropertyChanges {
							target: tabs
							frameVisible: true
							tabsVisible: true
							anchors.top: navigationBar.bottom
							anchors.bottom: browserWindow.bottom
							anchors.left: browserWindow.left
							anchors.right: browserWindow.right
						}
					}
				]
				settings.javascriptEnabled: true
				settings.pluginsEnabled: false
				settings.autoLoadIconsForPage: true
				settings.touchIconsEnabled: true

				onCertificateError: {
					error.defer();
					sslDialog.enqueue(error);
				}

				onStateChanged: {
					rootWindow.fullScreenOn = ( state == "FullScreen" )
				}

				onNewViewRequested: {
					if (!request.userInitiated)
						print("Warning: Blocked a popup window.");
					else if (request.destination == WebEngineView.NewViewInTab)
					{
						var tab = tabs.createEmptyTab(currentWebView.profile);
						tabs.currentIndex = tabs.count - 1;
						request.openIn(tab.item);
					}
					else if (request.destination == WebEngineView.NewViewInBackgroundTab)
					{
						var backgroundTab = tabs.createEmptyTab(currentWebView.profile);
						request.openIn(backgroundTab.item);
					}
					else if (request.destination == WebEngineView.NewViewInDialog)
					{
						var dialog = applicationRoot.createDialog(currentWebView.profile);
						request.openIn(dialog.currentWebView);
					}
					else
					{
						var window = applicationRoot.createWindow(currentWebView.profile);
						request.openIn(window.currentWebView);
					}
				}

				onFullScreenRequested: {
					if (request.toggleOn) {
						webEngineView.state = "FullScreen";
						fullScreenNotification.show();
					} else {
						webEngineView.state = "normalScreen";
						fullScreenNotification.hide();
					}
					request.accept();
				}

				onRenderProcessTerminated: {
					var status = "";
					switch (terminationStatus) {
					case WebEngineView.NormalTerminationStatus:
						status = "(normal exit)";
						break;
					case WebEngineView.AbnormalTerminationStatus:
						status = "(abnormal exit)";
						break;
					case WebEngineView.CrashedTerminationStatus:
						status = "(crashed)";
						break;
					case WebEngineView.KilledTerminationStatus:
						status = "(killed)";
						break;
					}

					print("Render process exited with code " + exitCode + " " + status);
					reloadTimer.running = true;
				}

				onWindowCloseRequested: {
					if (tabs.count == 1)
						browserWindow.close();
					else
						tabs.removeTab(tabs.currentIndex);
				}

				Timer {
					id: reloadTimer
					interval: 0
					running: false
					repeat: false
					onTriggered: currentWebView.reload()
				}
			}
		}
	}
	MessageDialog {
		id: sslDialog

		property var certErrors: []
		icon: StandardIcon.Warning
		standardButtons: StandardButton.No | StandardButton.Yes
		title: "Server's certificate not trusted"
		text: "Do you wish to continue?"
		detailedText: "If you wish so, you may continue with an unverified certificate. " +
					  "Accepting an unverified certificate means " +
					  "you may not be connected with the host you tried to connect to.\n" +
					  "Do you wish to override the security check and continue?"
		onYes: {
			certErrors.shift().ignoreCertificateError();
			presentError();
		}
		onNo: reject()
		onRejected: reject()

		function reject(){
			certErrors.shift().rejectCertificate();
			presentError();
		}
		function enqueue(error){
			certErrors.push(error);
			presentError();
		}
		function presentError(){
			visible = certErrors.length > 0
		}
	}

	FullScreenNotification {
		id: fullScreenNotification
	}

	DownloadView {
		id: downloadView
		visible: false
		anchors.fill: parent
	}

	function onDownloadRequested(download) {
		downloadView.visible = true;
		downloadView.append(download);
		download.accept();
	}

	Rectangle {
		id: statusBubble
		color: "oldlace"
		property int padding: 8

		anchors.left: parent.left
		anchors.bottom: parent.bottom
		width: statusText.paintedWidth + padding
		height: statusText.paintedHeight + padding

		Text {
			id: statusText
			anchors.centerIn: statusBubble
			elide: Qt.ElideMiddle

			Timer {
				id: resetStatusText
				interval: 750
				onTriggered: statusText.text = ""
			}
		}
	}
}
