#include "gpioreader.h"
#include <QFile>
#include <QDebug>

// Define a derived GpioReader class from QObject
GpioReader::GpioReader(QObject *parent)
    : QObject(parent)
{
}

// Method to read the GPIO value at gpio20 on bbb
int GpioReader::readValue()
{
    QFile f("/sys/class/gpio/gpio20/value");

    if (!f.open(QIODevice::ReadOnly)) {
        qDebug() << "Failed to open gpio20";
        return 0;
    }
    // return boolean value
    QByteArray data = f.readAll().trimmed();
    return (!data.isEmpty() && data[0] == '1') ? 1 : 0;
}
