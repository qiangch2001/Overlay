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

    if (v != lastValue) {

        if (lastValue == 0 && v == 1) {
            pressed = true;
        }

        else if (lastValue == 1 && v == 0) {

            if (pressed) {
                nightMode = !nightMode;      // 切换 Day/Night
                emit modeChanged(nightMode); // 通知 QML
                pressed = false;
            }
        }

        lastValue = v;
    }
}
