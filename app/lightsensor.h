#ifndef LIGHTSENSOR_H
#define LIGHTSENSOR_H

#include <QObject>

class LightSensor : public QObject
{
    Q_OBJECT
public:
    explicit LightSensor(QObject *parent = nullptr);

    Q_INVOKABLE int readAmbientLightValue();   // Read BH1750 Raw
    Q_INVOKABLE int computeAlpha(int raw);      // Compute alpha

};

#endif // LIGHTSENSOR_H
