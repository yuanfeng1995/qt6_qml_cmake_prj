import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: root
    property bool darkMode: false
    property string currentLang: "en"

    signal loginAttempted(string provider)

    spacing: 20
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter

    Text {
        text: currentLang === "en" ? "Sign in with" : "使用以下方式登录"
        font.pixelSize: 16
        font.bold: true
        color: darkMode ? "white" : "#333"
        Layout.alignment: Qt.AlignHCenter
    }

    Button {
        Layout.fillWidth: true
        text: "Google"
        icon.source: "qrc:/icons/google.png"
        background: Rectangle { color: "#ffffff"; border.color: "#ccc"; radius: 8 }
        onClicked: root.loginAttempted("Google")
    }

    Button {
        Layout.fillWidth: true
        text: "Microsoft"
        icon.source: "qrc:/icons/microsoft.png"
        background: Rectangle { color: "#2b579a"; radius: 8 }
        contentItem: Text { text: "Microsoft"; color: "white"; font.pixelSize: 15; anchors.centerIn: parent }
        onClicked: root.loginAttempted("Microsoft")
    }

    Button {
        Layout.fillWidth: true
        text: "GitHub"
        icon.source: "qrc:/icons/github.png"
        background: Rectangle { color: darkMode ? "#24292e" : "#000000"; radius: 8 }
        contentItem: Text { text: "GitHub"; color: "white"; font.pixelSize: 15; anchors.centerIn: parent }
        onClicked: root.loginAttempted("GitHub")
    }

    Text {
        text: currentLang === "en" ? "Your browser will open for authentication." : "浏览器将打开以完成授权。"
        font.pixelSize: 12
        color: darkMode ? "#aaa" : "#666"
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
    }
}
