#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QTimer>

#include "app/brightness.h"
#include "app/brtbackend.h"
#include "app/lightsensor.h"
#include "app/NightModeController.h"
#include "app/gpioreader.h"

void enableClickThrought(QQuickWindow* window) {
#ifdef Q_OS_WIN
    if(!window) return;

    HWND hwnd = reinterpret_cast<HWND>(window->winId());

    LONG exStyle = GetWindowLong(hwnd, GWL_EXSTYLE);
    exStyle |= WS_EX_LAYERED | WS_EX_TRANSPARENT;

    SetWindowLong(hwnd, GWL_EXSTYLE, exStyle);
#endif
}


int main(int argc, char *argv[]) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    Brightness br;
    engine.rootContext()->setContextProperty("Brightness", &br);

    BrtBackend backend;
    engine.rootContext()->setContextProperty("BrtBackend", &backend);

    LightSensor sensor;
    engine.rootContext()->setContextProperty("LightSensor", &sensor);

    GpioReader gpio;
    engine.rootContext()->setContextProperty("Gpio", &gpio);

    NightModeController nightModeCtrl;
    engine.rootContext()->setContextProperty("NightModeController", &nightModeCtrl);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if(!obj && url == objUrl) QCoreApplication::exit(-1);
            QQuickWindow* win = qobject_cast<QQuickWindow*>(obj);
            win->show();
            // QTimer::singleShot(100, [win](){enableClickThrought(win);});
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
