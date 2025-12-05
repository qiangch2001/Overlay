#include "sampling.h"

#include <fcntl.h>
#include <unistd.h>
#include <linux/fb.h>
#include <sys/ioctl.h>
#include <stdint.h>
#include <stdlib.h>

int capture_samples(double* samples, int maxSamples, double wR, double wG, double wB) {
    int fb = open("/dev/fb0", O_RDONLY);
    if (fb < 0) return 0;

    struct fb_var_screeninfo vinfo;
    ioctl(fb, FBIOGET_VSCREENINFO, &vinfo);

    int w   = vinfo.xres;
    int h   = vinfo.yres;
    int bpp = vinfo.bits_per_pixel / 8;

    size_t screensize = w * h * bpp;

    uint8_t* buffer = (uint8_t*)malloc(screensize);
    read(fb, buffer, screensize);
    close(fb);

    int idx = 0;
    const int step = 8;

    const double Rmax = (1 << vinfo.red.length)   - 1;
    const double Gmax = (1 << vinfo.green.length) - 1;
    const double Bmax = (1 << vinfo.blue.length)  - 1;

    for (int y = 0; y < h && idx < maxSamples; y += step) {
        for (int x = 0; x < w && idx < maxSamples; x += step) {

            uint32_t p = *((uint32_t*)(buffer + (y*w + x)*bpp));

            uint32_t Rraw = (p >> vinfo.red.offset)   & ((1 << vinfo.red.length)   - 1);
            uint32_t Graw = (p >> vinfo.green.offset) & ((1 << vinfo.green.length) - 1);
            uint32_t Braw = (p >> vinfo.blue.offset)  & ((1 << vinfo.blue.length)  - 1);

            double R = Rraw / Rmax;   // ✅ 0–1
            double G = Graw / Gmax;   // ✅ 0–1
            double B = Braw / Bmax;   // ✅ 0–1

            samples[idx++] = wR*R + wG*G + wB*B;  // ✅ 已是 0–1 物理亮度
        }
    }

    free(buffer);
    return idx;
}

