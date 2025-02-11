const float golden_ratio = (1.0 + sqrt(5.0)) * 0.5;

float fast_acos(float x) {
    float a = sqrt(2.0 + 2.0 * x);
    float b = sqrt(2.0 - 2.0 * x);
    float c = sqrt(2.0 - a);
    return 8.0 / 3.0 * c - b / 3.0;
}

mat3 rotationMatrix3(vec3 axis, float angle) {
    vec3 a = normalize(axis);
    float c = cos(angle);
    float s = sin(angle);

    return mat3(
        vec3(
            c + (1.0 - c) * a.x * a.x,
            (1.0 - c) * a.x * a.y - s * a.z,
            (1.0 - c) * a.x * a.z + s * a.y
        ),
        vec3(
            (1.0 - c) * a.x * a.y + s * a.z,
            c + (1.0 - c) * a.y * a.y,
            (1.0 - c) * a.y * a.z - s * a.x
        ),
        vec3(
            (1.0 - c) * a.x * a.z - s * a.y,
            (1.0 - c) * a.y * a.z + s * a.x,
            c + (1.0 - c) * a.z * a.z
        )
    );
}

vec3 complexPow(vec3 z, float to_power) {
	//float x = z3.x;
	//float y = z3.y;
	//float z = z3.z;
	// Lightship pow (sadly doesnt react to power)
	//return vec3((x * 2.0) - (y * 2.0) - (z * 2.0), y * (2.0 * x - z), z * (2.0 * x + y));
//	// Lightship attempt 2
	//return vec3((x * x) - (y * y) - (z * z), 2.0 * x * y, 2.0 * ((x - y) * z));

	// Bristorbrot pow
	//return vec3(pow(x, to_power) - pow(y, to_power) - pow(z, to_power), to_power * x * y, to_power * (x - y) * z);
	// Bristorbrot attempt 2
	//return vec3((x * x) - (y * y) - (z * z), y * (2.0 * x - z), z * (2.0 * x + y));

	// Daniel whites squaring formula
    //float r2 = dot(z3, z3);
    //float r = sqrt(r2);
    //float theta = to_power * atan(y, x);
    //float phi = to_power * asin(z / r);
//
    //return r2 * vec3(
        //cos(theta) * cos(phi),
        //sin(theta) * cos(phi),
        //-sin(phi)
    //);

	// Normal pow
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

//vec4 quat_ln(vec4 q) {
    //float r = length(q.xyz);
    //float t = (r > 0.00001) ? atan(r, q.w) / r : 0.0;
    //return vec4(q.xyz * t, 0.5 * log(dot(q, q)));
//}
//
//vec4 quat_exp(vec4 q) {
    //float r = length(q.xyz);
    //float et = exp(q.w);
    //float s = (r >= 0.00001) ? et * sin(r) / r : 0.0;
    //return vec4(q.xyz * s, et * cos(r));
//}
//
//vec4 quat_scale(vec4 q, float scale) {
    //return q * scale;
//}
//
//vec4 quat_pow(vec4 q, float n) {
    //return quat_exp(quat_scale(quat_ln(q), n));
//}

vec4 quat_pow(vec4 q, float n) {
    float angle = acos(q.w); // Extract the angle (theta) from the scalar part
    float sinAngle = sin(angle);

    if (sinAngle == 0.0) {
        return vec4(q.w, q.xyz); // If purely real, return the same quaternion
    }

    vec3 axis = q.xyz / sinAngle; // Normalize imaginary part
    float newAngle = angle * n;

    return vec4(cos(newAngle), axis * sin(newAngle));
}

float sphere_sdf3d(vec3 p, vec3 sphere_position, float radius) { return length(p - sphere_position) - radius; }
float sphere_sdf4d(vec4 p, vec4 sphere_position, float radius) { return length(p - sphere_position) - radius; }
float cube_sdf3d(vec3 p, vec3 s) {
	vec3 q = abs(p) - s;
	return length(max(q, 0.0));
}

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

//vec4 complexMul4(vec4 a, vec4 b) {
    //return vec4(
        //a.x * b.x - a.y * b.y - a.z * b.z - a.w * b.w,
        //a.x * b.y + a.y * b.x + a.z * b.w - a.w * b.z,
        //a.x * b.z - a.y * b.w + a.z * b.x + a.w * b.y,
        //a.x * b.w + a.y * b.z - a.z * b.y + a.w * b.x
    //);
//}
//
//vec4 complexDiv4(vec4 numerator, vec4 denominator) {
    //float denom = dot(denominator, denominator);
    //return complexMul4(numerator, vec4(denominator.x, -denominator.y, -denominator.z, -denominator.w)) / denom;
//}

//float smoothstep_mix(float a, float b, float t) {
    //t = clamp(t, 0.0, 1.0);
    //return mix(a, b, smoothstep(0.0, 1.0, t));
//}
//
//float lerp_mix(float a, float b, float t) {
    //t = clamp(t, 0.0, 1.0);
    //return mix(a, b, t);
//}

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

//float fast_atan(float y, float x) {
    //float a = y / (x + 0.00001);  // To avoid division by zero
    //return a / (1.0 + 0.28 * a * a);
//}
//
//float fast_sin(float x) {
    //float x2 = x * x;
    //float x3 = x2 * x;
    //float x5 = x3 * x2;
    //float x7 = x5 * x2;
//
    //return x - (x3 / 6.0) + (x5 / 120.0) - (x7 / 5040.0);
//}
//
//float fast_cos(float x) {
    //float x2 = x * x;
    //float x4 = x2 * x2;
    //float x6 = x4 * x2;
//
    //return 1.0 - (x2 / 2.0) + (x4 / 24.0) - (x6 / 720.0);
//}
//
//float fast_pow(float base, float exponent) {
    //return exp(exponent * log(base));
//}
//
//float fast_sqrt(float value) {
    //float guess = value * 0.5; // Initial guess
    //float tolerance = 0.0001;
    //float diff = 1.0;
//
    //while (diff > tolerance) {
        //float newGuess = 0.5 * (guess + value / guess);
        //diff = abs(newGuess - guess);
        //guess = newGuess;
    //}
//
    //return guess;
//}
//
//float fast_log(float x) {
    //x = (x - 1.0) / (x + 1.0);
    //float x2 = x * x;
    //return 2.0 * (x + x2 * (1.0 / 3.0 + x2 * (1.0 / 5.0 + x2 * (1.0 / 7.0))));
//}
