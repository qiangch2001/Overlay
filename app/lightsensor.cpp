#include "lightsensor.h"
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/i2c-dev.h>

LightSensor::LightSensor(QObject *parent)
    : QObject(parent)
{
}

// Fetch BH1750's raw data (YOUR ORIGINAL LOGIC)
int LightSensor::readAmbientLightValue()
{
    const char *dev = "/dev/i2c-2";

    int addr = 0x23;
    unsigned char cmd = 0x20;

    int fd = ::open(dev, O_RDWR);
    if (fd < 0) return -1;

    ioctl(fd, I2C_SLAVE, addr);
    ::write(fd, &cmd, 1);

    usleep(150000);

    unsigned char buf[2] = {0, 0};
    ::read(fd, buf, 2);
    ::close(fd);

    int raw = (buf[0] << 8) | buf[1];
    return raw;
}

// Convert raw → alpha (YOUR ORIGINAL LOGIC)
int LightSensor::computeAlpha(int raw)
{
    if (raw < 50) raw = 50;
    if (raw > 550) raw = 550;

    int alpha = raw * 255 / 550;

    return alpha;
}
