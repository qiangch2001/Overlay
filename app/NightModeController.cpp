#include "NightModeController.h"
#include <QFile>
#include <QDebug>
#include "gpioreader.h"

NightModeController::NightModeController(QObject *parent)
    : QObject(parent)
{
}

void NightModeController::poll()
{
    int v = GpioReader().readValue();   // read GPIO value

    if (v == 0) {
        nightMode = false;     // set to Day mode
    }
    else{
        nightMode = true;     // set to Night mode
    }
    emit modeChanged(nightMode);     // emit signal to QML
}
