import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Dialog {
    id: dialog
    width: 480
    height: 580
    modal: true
    dim: true
    focus: true
    standardButtons: Dialog.NoButton
    closePolicy: Popup.NoAutoClose

    property bool darkMode: false
    property string currentLang: "en"

    signal loginSuccess()

    Material.theme: darkMode ? Material.Dark : Material.Light
    Material.accent: Material.Blue

    opacity: 0.0
    scale: 0.96
    visible: false

    states: [
        State {
            name: "open"; PropertyChanges {
                target: dialog; opacity: 1.0; scale: 1.0; visible: true
            }
        },
        State {
            name: "closed"; PropertyChanges {
                target: dialog; opacity: 0.0; scale: 0.96; visible: false
            }
        }
    ]
    transitions: [Transition {
        NumberAnimation {
            properties: "opacity,scale"; duration: 250; easing.type: Easing.InOutQuad
        }
    }]

    function openDialog() {
        state = "open"
    }

    function closeDialog() {
        state = "closed"
    }

    background: Rectangle {
        color: darkMode ? "#2b2b2b" : "white"; radius: 16; border.color: darkMode ? "#444" : "#ccc"; border.width: 1
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 12
            ComboBox {
                id:
                    langSelect; model: ["English", "中文"]; currentIndex: currentLang === "en" ? 0 : 1; onActivated: (i) => currentLang = i === 0 ? "en" : "zh"; implicitWidth: 120
            }
            Button {
                icon.name: darkMode ? "weather-sunny" : "moon"; text: darkMode ? "Light" : "Dark"; flat: true; onClicked: darkMode = !darkMode
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4
            Image {
                source: "qrc:/images/logo.png";
                width: 72; height: 72; fillMode: Image.PreserveAspectFit
            }
            Text {
                text: currentLang === "en" ? "Welcome Back" : "欢迎回来"; font.pixelSize: 22; font.bold: true; color: darkMode ? "white" : "#333"
            }
        }

        TabBar {
            id: loginTabs
            Layout.fillWidth: true
            TabButton {
                text: currentLang === "en" ? "Account" : "账号登录"
            }
            TabButton {
                text: currentLang === "en" ? "Phone" : "手机登录"
            }
            TabButton {
                text: currentLang === "en" ? "OAuth" : "第三方登录"
            }
            property int previousIndex: 0
            onCurrentIndexChanged: {
                rootStack.switchDirection = currentIndex > previousIndex ? "forward" : "backward"
                previousIndex = currentIndex
                rootStack.setIndex(currentIndex)
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            StackView {
                id: rootStack
                anchors.fill: parent
                property string switchDirection: "forward"

                pushEnter: Transition {
                    NumberAnimation {
                        property: "x";
                        from: switchDirection === "forward" ? parent.width : -parent.width;
                        to: 0; duration: 250; easing.type: Easing.OutCubic
                    }
                }
                popExit: Transition {
                    NumberAnimation {
                        property: "x";
                        from: 0;
                        to: switchDirection === "forward" ? -parent.width : parent.width; duration: 250; easing.type: Easing.InCubic
                    }
                }

                initialItem: LoginAccountPage {
                    darkMode: dialog.darkMode
                    currentLang: dialog.currentLang
                    onLoginAttempted: (u, p, r) => tryLogin("account", u, p, r)
                }

                function setIndex(index) {
                    clear()
                    if (index === 0) push(accountPageComp)
                    else if (index === 1) push(phonePageComp)
                    else push(oauthPageComp)
                }

                Component {
                    id: accountPageComp; LoginAccountPage {
                        darkMode: dialog.darkMode; currentLang: dialog.currentLang; onLoginAttempted: (u, p, r) => tryLogin("account", u, p, r)
                    }
                }
                Component {
                    id: phonePageComp; LoginPhonePage {
                        darkMode: dialog.darkMode; currentLang: dialog.currentLang; onLoginAttempted: (p, c) => tryLogin("phone", p, c, false)
                    }
                }
                Component {
                    id: oauthPageComp; LoginOAuthPage {
                        darkMode: dialog.darkMode; currentLang: dialog.currentLang; onLoginAttempted: (prov) => {
                            showError((currentLang === "en" ? "Redirecting to " : "正在跳转到 ") + prov + "...");
                            Qt.callLater(() => loginSuccess())
                        }
                    }
                }
            }
        }

        Text {
            id: errorLabel
            text: ""
            color: "red"
            font.pixelSize: 13
            wrapMode: Text.WordWrap
            Layout.alignment: Qt.AlignHCenter
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8
            Text {
                text: currentLang === "en" ? "No account?" : "没有账号？";
                color: darkMode ? "#aaa" : "#666"
                font.pixelSize: 13
            }
            Button {
                text: currentLang === "en" ? "Sign up" : "注册"
                flat: true; font.pixelSize: 13
            }
        }
    }

    Timer {
        id: errorHideTimer; interval: 3500;
        onTriggered: text = ""
    }

    function tryLogin(method, user, pwdOrCode, remember) {
        if (user === "" || pwdOrCode === "") {
            showError(currentLang === "en" ? "Please fill all fields." : "请填写所有字段。");
            return
        }
        if ((method === "account" && user === "admin" && pwdOrCode === "1234") || (method === "phone" && pwdOrCode === "8888")) loginSuccess()
        else showError(currentLang === "en" ? "Invalid credentials." : "无效的登录信息。")
    }

    function showError(msg) {
        text = msg
        errorHideTimer.restart()
    }
}
