#ifndef GPIOREADER_H
#define GPIOREADER_H

#include <QObject>

class GpioReader : public QObject
{
    Q_OBJECT
public:
    explicit GpioReader(QObject *parent = nullptr);

    Q_INVOKABLE int readValue();   // 返回 0 或 1
};

#endif
