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
    Q_INVOKABLE void setUserRGBWeights(double r, double g, double b);

private:
    BrightnessAlgo algo;   // 默认算法

    double m_wR = 0.299;
    double m_wG = 0.587;
    double m_wB = 0.114;
};

#endif // BRIGHTNESS_H
