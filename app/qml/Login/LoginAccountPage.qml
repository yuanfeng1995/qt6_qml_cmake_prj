import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: root
    property alias username: userField.text
    property alias password: passField.text
    property alias remember: rememberBox.checked
    property bool darkMode: false
    property string currentLang: "en"

    signal loginAttempted(string user, string password, bool remember)

    spacing: 14
    Layout.fillWidth: true

    TextField {
        id: userField
        placeholderText: currentLang === "en" ? "Username or Email" : "用户名或邮箱"
        Layout.fillWidth: true
    }

    TextField {
        id: passField
        placeholderText: currentLang === "en" ? "Password" : "密码"
        echoMode: showPwd.checked ? TextInput.Normal : TextInput.Password
        Layout.fillWidth: true
    }

    Button {
        id: showPwd
        text: checked
              ? (currentLang === "en" ? "Hide" : "隐藏")
              : (currentLang === "en" ? "Show" : "显示")
        checkable: true
        flat: true
        Layout.alignment: Qt.AlignRight
    }

    CheckBox {
        id: rememberBox
        text: currentLang === "en" ? "Remember me" : "记住我"
    }

    Button {
        text: currentLang === "en" ? "Sign In" : "登录"
        Layout.fillWidth: true
        highlighted: true
        onClicked: root.loginAttempted(userField.text, passField.text, rememberBox.checked)
    }
}
