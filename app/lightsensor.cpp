#include "lightsensor.h"
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/i2c-dev.h>

// Define a derived LightSensor class from QObject
LightSensor::LightSensor(QObject *parent)
    : QObject(parent)
{
}

// Fetch BH1750's raw data
int LightSensor::readAmbientLightValue()
{
    const char *dev = "/dev/i2c-2";

    // Secondary address of BH1750
    int addr = 0x23;
    // One time high-res mode
    unsigned char cmd = 0x20;
    // Open i2c device
    int fd = ::open(dev, O_RDWR);
    if (fd < 0) return -1;
    // Set secondary address
    ioctl(fd, I2C_SLAVE, addr);
    // Send measurement command
    ::write(fd, &cmd, 1);

    // Wait for measurement to complete( at least 120ms)
    usleep(150000);

    unsigned char buf[2] = {0, 0};
    ::read(fd, buf, 2);
    ::close(fd);

    // Combine the two bytes from the sensor
    int raw = (buf[0] << 8) | buf[1];
    return raw;
}

// Convert rawdata to alpha
int LightSensor::computeAlpha(int raw)
{
    // Clamp raw data to [50, 550]
    if (raw < 50) raw = 50;
    if (raw > 550) raw = 550;

    // Map [50, 550] to [0, 255]
    int alpha = raw * 255 / 550;

    return alpha;
}
