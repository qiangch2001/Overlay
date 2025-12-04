#include "sampling.h"

#include <windows.h>
#include <stdint.h>

// =================== 截屏 + 采样函数 =====================
// 返回采样数量，samples[] 必须有足够空间
int capture_samples(double* samples, int maxSamples) {
    HDC hScreenDC = GetDC(NULL);
    if(!hScreenDC) return 0;

    HDC hMemDC = CreateCompatibleDC(hScreenDC);
    if(!hMemDC) {
        ReleaseDC(NULL, hScreenDC);
        return 0;
    }

    int w = GetSystemMetrics(SM_CXSCREEN);
    int h = GetSystemMetrics(SM_CYSCREEN);

    HBITMAP hBitmap = CreateCompatibleBitmap(hScreenDC, w, h);
    if(!hBitmap) {
        DeleteDC(hMemDC);
        ReleaseDC(NULL, hScreenDC);
        return 0;
    }

    HGDIOBJ oldObj = SelectObject(hMemDC, hBitmap);
    BitBlt(hMemDC, 0, 0, w, h, hScreenDC, 0, 0, SRCCOPY);
    SelectObject(hMemDC, oldObj);

    BITMAPINFO bmi = {0};
    bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bmi.bmiHeader.biWidth = w;
    bmi.bmiHeader.biHeight = -h;
    bmi.bmiHeader.biPlanes = 1;
    bmi.bmiHeader.biBitCount = 32;

    uint8_t* pixels = (uint8_t*)malloc(4 * w * h);
    if(!pixels) {
        DeleteObject(hBitmap);
        DeleteDC(hMemDC);
        ReleaseDC(NULL, hScreenDC);
        return 0;
    }

    GetDIBits(hScreenDC, hBitmap, 0, h, pixels, &bmi, DIB_RGB_COLORS);

    const int step = 8;
    int idx = 0;

    for(int y = 0; y < h && idx < maxSamples; y += step) {
        uint8_t* row = pixels + y * w * 4;
        for(int x = 0; x < w && idx < maxSamples; x += step) {

            uint8_t B = row[x*4 + 0];
            uint8_t G = row[x*4 + 1];
            uint8_t R = row[x*4 + 2];

            double Y = 0.299*R + 0.587*G + 0.114*B;
            samples[idx++] = Y / 255.0;  // normalize
        }
    }

    free(pixels);
    DeleteObject(hBitmap);
    DeleteDC(hMemDC);
    ReleaseDC(NULL, hScreenDC);

    return idx;
}
