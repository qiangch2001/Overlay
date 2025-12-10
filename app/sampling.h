#ifndef SAMPLING_H
#define SAMPLING_H

// Function to capture screen samples on BeagleBone Black
// Parameters:
//   samples: pointer to an array to store sampled luminance values
//   maxSamples: maximum number of samples to capture
//   wR, wG, wB: weights for red, green, and blue channels
// Returns:
//   number of samples actually captured
int capture_samples(double* samples, int maxSamples, double wR, double wG, double wB);

#endif // SAMPLING_H
