#ifndef NIGHTMODECONTROLLER_H
#define NIGHTMODECONTROLLER_H

#include <QObject>

class NightModeController : public QObject
{
    Q_OBJECT

public:
    explicit NightModeController(QObject *parent = nullptr);

    Q_INVOKABLE void poll();  // Poll periodically for GPIO value

    Q_INVOKABLE bool isNightMode() const { return nightMode; }

signals:
    void modeChanged(bool night);  // Indicate mode change to QML

private:
    bool nightMode = false; // False=Day, true=Night
};

#endif // NIGHTMODECONTROLLER_H
