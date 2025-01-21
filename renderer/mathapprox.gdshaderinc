float fast_acos(float x) {
    float a = sqrt(2.0 + 2.0 * x);
    float b = sqrt(2.0 - 2.0 * x);
    float c = sqrt(2.0 - a);
    return 8.0 / 3.0 * c - b / 3.0;
}

float fast_atan(float y, float x) {
    float a = y / (x + 0.00001);  // To avoid division by zero
    return a / (1.0 + 0.28 * a * a);
}

float fast_sin(float x) {
    float x2 = x * x;
    float x3 = x2 * x;
    float x5 = x3 * x2;
    float x7 = x5 * x2;

    return x - (x3 / 6.0) + (x5 / 120.0) - (x7 / 5040.0);
}

float fast_cos(float x) {
    float x2 = x * x;
    float x4 = x2 * x2;
    float x6 = x4 * x2;

    return 1.0 - (x2 / 2.0) + (x4 / 24.0) - (x6 / 720.0);
}

float fast_pow(float base, float exponent) {
    return exp(exponent * log(base));
}

float fast_sqrt(float value) {
    float guess = value * 0.5; // Initial guess
    float tolerance = 0.0001;
    float diff = 1.0;

    while (diff > tolerance) {
        float newGuess = 0.5 * (guess + value / guess);
        diff = abs(newGuess - guess);
        guess = newGuess;
    }

    return guess;
}

float fast_log(float x) {
    x = (x - 1.0) / (x + 1.0);
    float x2 = x * x;
    return 2.0 * (x + x2 * (1.0 / 3.0 + x2 * (1.0 / 5.0 + x2 * (1.0 / 7.0))));
}
