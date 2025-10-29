import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: root
    property alias phone: phoneField.text
    property alias code: codeField.text
    property bool darkMode: false
    property string currentLang: "en"

    signal loginAttempted(string phone, string code)

    spacing: 14
    Layout.fillWidth: true

    TextField {
        id: phoneField
        placeholderText: currentLang === "en" ? "Phone Number" : "手机号"
        Layout.fillWidth: true
    }

    RowLayout {
        Layout.fillWidth: true
        TextField {
            id: codeField
            placeholderText: currentLang === "en" ? "Verification Code" : "验证码"
            Layout.fillWidth: true
        }
        Button {
            text: currentLang === "en" ? "Send" : "发送"
            onClicked: console.log("验证码已发送")
        }
    }

    Button {
        text: currentLang === "en" ? "Sign In" : "登录"
        Layout.fillWidth: true
        highlighted: true
        onClicked: root.loginAttempted(phoneField.text, codeField.text)
    }
}
