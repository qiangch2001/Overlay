#include "gpioreader.h"
#include <QFile>
#include <QDebug>

GpioReader::GpioReader(QObject *parent)
    : QObject(parent)
{
}

int GpioReader::readValue()
{
    QFile f("/sys/class/gpio/gpio20/value");

    if (!f.open(QIODevice::ReadOnly)) {
        qDebug() << "Failed to open gpio20";
        return 0;
    }

    QByteArray data = f.readAll().trimmed();
    return (!data.isEmpty() && data[0] == '1') ? 1 : 0;
}
