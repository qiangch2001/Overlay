#ifndef BRIGHTNESS_H
#define BRIGHTNESS_H

#include <QObject>

typedef double (*BrightnessAlgo)(double* samples, int count);

class Brightness : public QObject {
    Q_OBJECT
public:
    explicit Brightness(QObject* parent = nullptr);

    Q_INVOKABLE double readScreenLuminance();
    Q_INVOKABLE void setAlgorithm(int method);

private:
    BrightnessAlgo algo;   // 默认算法
};

#endif // BRIGHTNESS_H
