float fast_acos(float x) {
    float a = sqrt(2.0 + 2.0 * x);
    float b = sqrt(2.0 - 2.0 * x);
    float c = sqrt(2.0 - a);
    return 8.0 / 3.0 * c - b / 3.0;
}

vec3 complexPow(vec3 z, float to_power) {
	float r = length(z); // Magnitude of z
	float theta = acos(z.z / r); // Polar angle (theta)
	float phi = atan(z.y, z.x); // Azimuthal angle (phi)

	// Raise the magnitude to the power
	float r_pow = pow(r, to_power);

	// Multiply the angles by the power
	float theta_pow = to_power * theta;
	float phi_pow = to_power * phi;

	// Convert back to Cartesian coordinates
	vec3 result = r_pow * vec3(
		sin(theta_pow) * cos(phi_pow),
		sin(theta_pow) * sin(phi_pow),
		cos(theta_pow)
	);

	return result;
}

vec4 complexPow4(vec4 z, float to_power) {
	// Treat the vec4 as two separate complex numbers: (x, y) and (z, w)
	vec2 complex1 = vec2(z.x, z.y);
	vec2 complex2 = vec2(z.z, z.w);

	// Compute the magnitude and angle for each complex number
	float r1 = length(complex1);
	float r2 = length(complex2);
	float theta1 = atan(complex1.y, complex1.x);
	float theta2 = atan(complex2.y, complex2.x);

	// Raise the magnitudes to the power
	float r1_pow = pow(r1, to_power);
	float r2_pow = pow(r2, to_power);

	// Multiply the angles by the power
	float theta1_pow = to_power * theta1;
	float theta2_pow = to_power * theta2;

	// Convert back to Cartesian coordinates for each complex number
	vec2 result1 = r1_pow * vec2(cos(theta1_pow), sin(theta1_pow));
	vec2 result2 = r2_pow * vec2(cos(theta2_pow), sin(theta2_pow));

	// Combine the results into a vec4
	return vec4(result1, result2);
}

float sphere_sdf3d(vec3 p, vec3 sphere_position, float radius) { return length(p - sphere_position) - radius; }
float sphere_sdf4d(vec4 p, vec4 sphere_position, float radius) { return length(p - sphere_position) - radius; }

vec3 negative_sqrt(vec3 v) {
	vec3 square_root = sqrt(abs(v));
	if (v.x <= 0.0) square_root.x = -square_root.x;
	if (v.y <= 0.0) square_root.y = -square_root.y;
	if (v.z <= 0.0) square_root.z = -square_root.z;
	return square_root;
}

vec4 quatConjugate(vec4 q) { return vec4(-q.xyz, q.w); }
float quatNormSquared(vec4 q) { return dot(q, q); }
vec4 quatInverse(vec4 q) { float normSquared = quatNormSquared(q); return quatConjugate(q) / normSquared; }

vec4 complexMul4(vec4 a, vec4 b) {
    return vec4(
        a.x * b.x - a.y * b.y - a.z * b.z - a.w * b.w,
        a.x * b.y + a.y * b.x + a.z * b.w - a.w * b.z,
        a.x * b.z - a.y * b.w + a.z * b.x + a.w * b.y,
        a.x * b.w + a.y * b.z - a.z * b.y + a.w * b.x
    );
}

vec4 complexDiv4(vec4 numerator, vec4 denominator) {
    float denom = dot(denominator, denominator);
    return complexMul4(numerator, vec4(denominator.x, -denominator.y, -denominator.z, -denominator.w)) / denom;
}

//vec4 mobiusTransform(vec4 z, vec4 a, vec4 b, vec4 c, vec4 d) {
    //vec4 numerator = complexMul4(a, z) + b;
    //vec4 denominator = complexMul4(c, z) + d;
    //return complexDiv4(numerator, denominator);
//}

// Sphere inversion: Reflect a point across a sphere
vec3 sphereInversion(vec3 p, vec3 center, float radius) {
    vec3 delta = p - center;
    float distSq = dot(delta, delta);
    return center + (radius * radius / distSq) * delta;
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
