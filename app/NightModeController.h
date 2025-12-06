#ifndef NIGHTMODECONTROLLER_H
#define NIGHTMODECONTROLLER_H

#include <QObject>

class NightModeController : public QObject
{
    Q_OBJECT

public:
    explicit NightModeController(QObject *parent = nullptr);

    Q_INVOKABLE void poll();  // 定时轮询 GPIO

    Q_INVOKABLE bool isNightMode() const { return nightMode; }

signals:
    void modeChanged(bool night);  // 通知 QML 切换配色

private:
    int readSensorValue();  // 读取 GPIO
    bool nightMode = false; // false=Day, true=Night
};

#endif // NIGHTMODECONTROLLER_H
