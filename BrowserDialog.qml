import QtQuick 2.1
import QtQuick.Window 2.2
import QtWebEngine 1.2

Window {
    property alias currentWebView: webView
    flags: Qt.Dialog
    width: 800
    height: 600
    visible: true
//    onClosing: destroy()
    WebEngineView {
        id: webView
        anchors.fill: parent
    }
}
