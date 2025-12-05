#ifndef LIGHTSENSOR_H
#define LIGHTSENSOR_H

#include <QObject>

class LightSensor : public QObject
{
    Q_OBJECT
public:
    explicit LightSensor(QObject *parent = nullptr);

    Q_INVOKABLE int readAmbientLightValue();   // 读 BH1750 Raw
    Q_INVOKABLE int computeAlpha(int raw);      // 按你旧逻辑算 alpha

};

#endif // LIGHTSENSOR_H
