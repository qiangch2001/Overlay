#include "brightness.h"
#include <QQuickWindow>
#include <QQuickWindow>

#include "sampling.h"

double algo_physical(double* L, int count) {
    double sum = 0;
    for(int i = 0; i < count; i++)
        sum += L[i];
    return sum / count;
}

static int cmp_double(const void* a, const void* b) {
    double x = *(double*)a;
    double y = *(double*)b;
    return (x > y) - (x < y);
}

static double topK(double* L, int count, double K_ratio) {
    if (count <= 0) return 0.0;

    qsort(L, count, sizeof(double), cmp_double);

    int start = (int)(count * (1.0 - K_ratio));
    if (start < 0) start = 0;

    double sum = 0;
    int N = count - start;

    for(int i = start; i < count; i++)
        sum += L[i];

    return sum / N;
}

double algo_topk5(double* L, int count) {
    return topK(L, count, 0.05);
}

double algo_topk10(double* L, int count) {
    return topK(L, count, 0.10);
}

double algo_weighted(double* L, int count) {
    double sum = 0, wsum = 0;

    for(int i = 0; i < count; i++) {
        double w = (L[i] < 0.1 || L[i] > 0.9) ? 0.2 : 1.0; // pixels too dark or too bright get lower weight
        sum += L[i] * w;
        wsum += w;
    }
    return sum / wsum;
}

// Compute screen luminance using the specified algorithm and RGB weights
static double compute_screen_luminance(BrightnessAlgo algo, double wR, double wG, double wB) {
    const int MAX_SAMPLES = 20000;
    double* samples = (double*)malloc(sizeof(double) * MAX_SAMPLES);

    int count = capture_samples(samples, MAX_SAMPLES, wR, wG, wB);
    if(count <= 0) {
        free(samples);
        return 0.0;
    }

    double result = algo(samples, count);
    // printf("count=%d, luminance=%.4f\n", count, result);
    free(samples);
    return result;
}

Brightness::Brightness(QObject* parent): QObject(parent) {
    algo = algo_physical; // default algorithm
}

void Brightness::setAlgorithm(int method) {
    switch(method) {
    case 0: algo = algo_physical; break;
    case 1: algo = algo_topk5;    break;
    case 2: algo = algo_topk10;   break;
    case 3: algo = algo_weighted; break;
    default:
        algo = algo_physical;
        break;
    }
}

double Brightness::readScreenLuminance() {
    return compute_screen_luminance(algo, m_wR, m_wG, m_wB);
}

void Brightness::setUserRGBWeights(double r, double g, double b) {
    m_wR = r;
    m_wG = g;
    m_wB = b;
}
