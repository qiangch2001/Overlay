#ifndef BRIGHTNESS_H
#define BRIGHTNESS_H

#include <QObject>

typedef double (*BrightnessAlgo)(double* samples, int count); // the function pointer type for brightness algorithms

// Brightness class to read screen luminance
// members:
//   algo: the selected brightness algorithm
// methods:
//   readScreenLuminance(): read the current screen luminance
//   setAlgorithm(int method): set the brightness algorithm
//   setUserRGBWeights(double r, double g, double b): set user-defined RGB weights
// Note: The default RGB weights are set to 0.2126, 0.7152, and 0.0722
//       corresponding to the perceived brightness of red, green, and blue
//       as defined in the Rec. 709 standard.
class Brightness : public QObject {
    Q_OBJECT
public:
    explicit Brightness(QObject* parent = nullptr);

    Q_INVOKABLE double readScreenLuminance();
    Q_INVOKABLE void setAlgorithm(int method);
    Q_INVOKABLE void setUserRGBWeights(double r, double g, double b);

private:
    BrightnessAlgo algo;   // 默认算法

    double m_wR = 0.2126;
    double m_wG = 0.7152;
    double m_wB = 0.0722;
};

#endif // BRIGHTNESS_H
