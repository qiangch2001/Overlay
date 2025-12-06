#include "NightModeController.h"
#include <QFile>
#include <QDebug>

NightModeController::NightModeController(QObject *parent)
    : QObject(parent)
{
}

int NightModeController::readSensorValue()
{
    QFile f("/sys/class/gpio/gpio20/value");

    if (!f.open(QIODevice::ReadOnly)) {
        qDebug() << "Failed to open gpio20";
        return 0;
    }

    QByteArray data = f.readAll().trimmed();
    return (!data.isEmpty() && data[0] == '1') ? 1 : 0;
}

void NightModeController::poll()
{
    int v = readSensorValue();

    if (v == 0) {
        nightMode = false;    // set to Day mode
    }
    else{
        nightMode = true;     // set to Night mode
    }
    emit modeChanged(nightMode); // emit signal
}
