#include "sampling.h"

#include <fcntl.h>
#include <unistd.h>
#include <linux/fb.h>
#include <sys/ioctl.h>
#include <stdint.h>

int capture_samples(double* samples, int maxSamples)
{
    int fb = open("/dev/fb0", O_RDONLY);
    if (fb < 0) return 0;

    struct fb_var_screeninfo vinfo;
    ioctl(fb, FBIOGET_VSCREENINFO, &vinfo);

    int w = vinfo.xres;
    int h = vinfo.yres;
    int bpp = vinfo.bits_per_pixel / 8;

    size_t screensize = w * h * bpp;

    uint8_t* buffer = (uint8_t*)malloc(screensize);
    read(fb, buffer, screensize);
    close(fb);

    int idx = 0;
    const int step = 8;

    for(int y=0;y<h && idx<maxSamples; y+=step){
        for(int x=0;x<w && idx<maxSamples; x+=step){

            uint32_t p = *((uint32_t*)(buffer + (y*w + x)*bpp));

            uint8_t R = (p >> vinfo.red.offset)   & ((1<<vinfo.red.length)-1);
            uint8_t G = (p >> vinfo.green.offset) & ((1<<vinfo.green.length)-1);
            uint8_t B = (p >> vinfo.blue.offset)  & ((1<<vinfo.blue.length)-1);

            samples[idx++] = (0.299*R + 0.587*G + 0.114*B) / 255.0;
        }
    }

    free(buffer);
    return idx;
}
