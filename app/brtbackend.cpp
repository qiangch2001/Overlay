#include "brtbackend.h"

BrtBackend::BrtBackend(QObject* parent)
    : QObject(parent) {}

void BrtBackend::setWR(double v) { m_wR = v; emit weightsChanged(); }
void BrtBackend::setWG(double v) { m_wG = v; emit weightsChanged(); }
void BrtBackend::setWB(double v) { m_wB = v; emit weightsChanged(); }
