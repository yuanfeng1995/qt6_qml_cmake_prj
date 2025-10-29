#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWKQuick/qwkquickglobal.h>
#include <QQuickWindow>
#include <QQmlContext>

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    // 禁止窗口重定向
    // Qt 会尝试直接在原生窗口表面（native surface）绘制，而不是先画到中间缓冲。
    qputenv("QT_QPA_DISABLE_REDIRECTION_SURFACE", "1");
#endif

    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);
    const QGuiApplication app(argc, argv);
    QQuickWindow::setDefaultAlphaBuffer(true);
    QQmlApplicationEngine engine;
    QWK::registerTypes(&engine);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, [](const QUrl &url)
    {
        qCritical() << "QQmlApplicationEngine::objectCreationFailed" << url;
        QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.loadFromModule(APP_NAME + std::string{"_Main"}, "Main");
    engine.loadFromModule(APP_NAME + std::string{"_Login"}, "LoginDialog");

    return QGuiApplication::exec();
}
