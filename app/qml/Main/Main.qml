import QtQuick
import QtQuick.Window
import QtQuick.Controls

FramelessWindow {
    Button {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 20
        }
        text: qsTr("Open Child Window")
        onClicked: console.log(text)
    }
}