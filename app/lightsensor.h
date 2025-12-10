#ifndef LIGHTSENSOR_H
#define LIGHTSENSOR_H

#include <QObject>

class LightSensor : public QObject
{
    Q_OBJECT
public:
    explicit LightSensor(QObject *parent = nullptr);

    Q_INVOKABLE int readAmbientLightValue();
    Q_INVOKABLE int computeAlpha(int raw);

};

#endif // LIGHTSENSOR_H
