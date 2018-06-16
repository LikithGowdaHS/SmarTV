import QtQuick 2.6
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

Rectangle {
	id:delegate
	color: Material.background
    border.color: "LightBlue"
	Column {
		id: container
		property alias fileText: fName.text
		anchors.fill: parent
		padding: 5
		spacing: 2
		Image {
			id: icon
			width: delegate.height - 25
			height:width
            source: {
                fileIsDir ? "qrc:/Images/FolderIcon.svg" : getIconPath( fileURL )
            }
            anchors.horizontalCenter: parent.horizontalCenter

            function getIconPath(fileUrl)
            {
                var patt = /txt$/
                if(patt.test(fileUrl))
                    return "qrc:/Images/TextFileIcon.png"
                else
                {
                    patt = /pdf$/
                    if(patt.test(fileUrl))
                        return "qrc:/Images/PDFFileIcon.png"
                    else
                    {
                        patt = /png$/
                        var patt2 = /jpg$/
                        if( patt.test(fileUrl) || patt2.test(fileUrl) )
                            return "qrc:/Images/ImageFileIcon.png"
                        else
                        {
                            patt = /mkv$/
                            patt2 = /mp4$/
                            var patt3 = /avi$/
                            if( patt.test(fileUrl) || patt2.test(fileUrl) || patt3.test(fileUrl) )
                                return "qrc:/Images/VideoFileIcon.png"
                        }
                        return "qrc:/Images/OtherFileIcon.png"
                    }
                }
            }
		}
		Label {
			id: fName
			text: fileName
			width: implicitWidth > ( container.width - 5 ) ? ( container.width - 5 ) : implicitWidth
			elide: Label.ElideRight
			anchors.horizontalCenter: parent.horizontalCenter
            leftPadding: 4
            rightPadding: 4
		}
	}
	MouseArea {
		id:mouseArea
		anchors.fill: parent
		hoverEnabled: true
		onClicked: fileIsDir ? view.path = fileURL : Qt.openUrlExternally(fileURL)
		onEntered: { toolTip.visible = true }
		onExited:  { toolTip.visible = false }
	}
    function getAbsolutePosition(node) {
          var returnPos = {};
          returnPos.x = 0;
          returnPos.y = 0;
          if(node !== undefined && node !== null) {
              var parentValue = getAbsolutePosition(node.parent);
              returnPos.x = parentValue.x + node.x;
              returnPos.y = parentValue.y + node.y;
          }
          return returnPos;
      }

	ToolTip{
		id:toolTip
		text: fileName
        background:Rectangle {
            border.color: "#444"
        }
        y: mouseArea.height-5
	}

}
