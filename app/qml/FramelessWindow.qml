import QtQuick
import QtQuick.Window
import QtQuick.Controls
import Qt.labs.platform
import QWindowKit

Window {
    id: window
    title: qsTr("QtQuick Demo")
    width: 800
    height: 600
    color: "#55710808"
    visible: false

    Component.onCompleted: {
        Qt.callLater(function () {
            windowAgent.setup(window)
            windowAgent.setTitleBar(titleBar)
            windowAgent.setSystemButton(WindowAgent.Minimize, minButton)
            windowAgent.setSystemButton(WindowAgent.Maximize, maxButton)
            windowAgent.setSystemButton(WindowAgent.Close, closeButton)
            window.visible = true
        })
    }

    WindowAgent {
        id: windowAgent
    } 

    Rectangle {
        id: titleBar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 32
        color: "transparent"

        Row {
            anchors {
                top: parent.top
                right: parent.right
            }
            height: parent.height

            Button {
                id: minButton
                width: 36
                height: parent.height
                Accessible.name: "minimize"
                onClicked: window.showMinimized()
            }

            Button {
                id: maxButton
                width: 36
                height: parent.height
                Accessible.name: window.visibility === Window.Maximized ? "normal" : "maximize"
                onClicked: {
                    if (window.visibility === Window.Maximized) {
                        window.showNormal()
                    } else {
                        window.showMaximized()
                    }
                }
            }

            Button {
                width: 36
                id: closeButton
                height: parent.height
                Accessible.name: "close"
                background: Rectangle {
                    color: {
                        if (!closeButton.enabled) {
                            return "gray";
                        }
                        if (closeButton.pressed) {
                            return "#e81123";
                        }
                        if (closeButton.hovered) {
                            return "#e81123";
                        }
                        return "transparent";
                    }
                }
                onClicked: window.close()
            }
        }
    }

}
