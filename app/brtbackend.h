// BrightnessBackend.h
#pragma once
#include <QObject>

// BrtBackend class to manage RGB weights for brightness calculation
// members:
//   wR, wG, wB: RGB weights
// methods:
//   setWR(double v), setWG(double v), setWB(double v): set RGB weights
// signals:
//   weightsChanged(): emitted when any weight is changed
class BrtBackend : public QObject {
    Q_OBJECT
    Q_PROPERTY(double wR READ wR WRITE setWR NOTIFY weightsChanged)
    Q_PROPERTY(double wG READ wG WRITE setWG NOTIFY weightsChanged)
    Q_PROPERTY(double wB READ wB WRITE setWB NOTIFY weightsChanged)

public:
    explicit BrtBackend(QObject* parent = nullptr);

    double wR() const { return m_wR; }
    double wG() const { return m_wG; }
    double wB() const { return m_wB; }

public slots:
    void setWR(double v);
    void setWG(double v);
    void setWB(double v);

signals:
    void weightsChanged();

private:
    double m_wR = 0.2126;
    double m_wG = 0.7152;
    double m_wB = 0.0722;
};
