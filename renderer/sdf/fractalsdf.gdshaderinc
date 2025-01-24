#include "res://renderer/mathapprox.gdshaderinc"

vec3 complexPow(vec3 z, float to_power) {
	float r = length(z); // Magnitude of z
	float theta = fast_acos(z.z / r); // Polar angle (theta)
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

////////////////
// Mandelbulb //
////////////////

vec2 mandelbulb_sdf(vec3 p, out vec3 final_z) {
	vec3 scaled_p = p * size;
	vec3 z = vec3(0.00001, 0.0, 0.0);
	vec3 c = scaled_p;
	
	float r = length(z);
	float dz = 1.0;
	float powercache1 = (power - 1.0) * 0.5;
	
	for (int i = 0; i < int(iterations); i++) {
		dz = power * pow(r, powercache1) * dz + 1.0;
		float th = power * fast_acos(z.z / r);
		float ph = power * atan(z.y, z.x);
		z = complexPow(z, power);
		z += c;
		
		// Break condition
		r = length(z);
		
		if (r > 2.0) {
			final_z = z;
			return vec2(0.8 * log(r) * sqrt(r) / dz, float(i));
		};
	}
	
	final_z = z;
	return vec2(0.8 * log(r) * sqrt(r) / dz, float(iterations));
}

///////////////
// Juliabulb //
///////////////

vec2 juliabulb_sdf(vec3 p, out vec3 final_z) {
	vec3 scaled_p = p * size;
	vec3 z = scaled_p;
	vec3 c = fjuliabulb_c;
	
	float r = length(z);
	float dz = 1.0;
	float powercache1 = (power - 1.0) * 0.5;
	
	for (int i = 0; i < int(iterations); i++) {
		dz = power * pow(r, powercache1) * dz + 1.0;
		float th = power * fast_acos(z.z / r);
		float ph = power * atan(z.y, z.x);
		
		z = complexPow(z, power);
		z += c;
		
		// Break condition
		r = length(z);
		
		if (r > 2.0) {
			final_z = z;
			return vec2(0.8 * log(r) * sqrt(r) / dz, float(i));
		};
	}
	
	final_z = z;
	return vec2(0.8 * log(r) * sqrt(r) / dz, float(iterations));
}

//////////////////
// Burning ship //
//////////////////

vec2 burning_ship_sdf(vec3 p, out vec3 final_z) {
	vec3 scaled_p = p * size;
	vec3 z = vec3(0.00001, 0.0, 0.0);
	vec3 c = scaled_p;
	
	float r = length(z);
	float dz = 1.0;
	float powercache1 = (power - 1.0) * 0.5;
	
	for (int i = 0; i < int(iterations); i++) {
		dz = power * pow(r, powercache1) * dz + 1.0;
		float th = power * acos(z.z / r);
		float ph = power * atan(z.y, z.x);
		z = abs(z);
		z = complexPow(z, power);
		z += c;
		
		// Break condition
		r = length(z);
		
		if (r > 2.0) {
			final_z = z;
			return vec2(0.5 * log(r) * sqrt(r) / dz, float(i));
		};
	}
	
	final_z = z;
	return vec2(0.5 * log(r) * sqrt(r) / dz, float(iterations));
}

///////////////
// Mandelbox //
///////////////

float sphereFold(vec4 z, float minR, float maxR, float bloatFactor) { // bloat = 1 will not change size.
	float r2 = dot(z.xyz, z.xyz);
	return max(maxR / max(minR, r2), bloatFactor);
}
void boxFold(inout vec4 z, vec3 r) {
	z.xyz = clamp(z.xyz, -r, r) * 2.0 - z.xyz;
}

float de_box(vec4 p, vec3 s) {
	vec3 a = abs(p.xyz) - s;
	return (min(max(max(a.x, a.y), a.z), 0.0) + length(max(a, 0.0))) / p.w;
}

float sineWave(float x, float from, float to) {
    float amplitude = (to - from) / 2.0; // Amplitude
    float offset = (to + from) / 2.0;    // Vertical offset
    float frequency = 1.0;               // Default frequency
    float phase = 0.0;                   // Default phase
    return amplitude * sin(2.0 * 3.14159 * frequency * x + phase) + offset;
}

vec2 mandelbox_sdf(vec3 pos) {
	vec4 p = vec4(pos, 1);
	p *= 4.0;
	vec4 o = p;
	
	for (int i = 0; i < iterations; i++) {
		boxFold(p, fmandelbox_box_size);
		p *= sphereFold(p, fmandelbox_sphere_fold.x, fmandelbox_sphere_fold.y, fmandelbox_sphere_fold.z) * power;
		p += o * fmandelbox_spread;
		p += sin(o) * fmandelbox_stoneness;
		p += sin(o - p) * fmandelbox_divisions;
		//o = complexPow4(o, fmandelbox_stoneness);
		//o += sin(o * (sin(p) * fmandelbox_stoneness));
	}
	
	return vec2(de_box(p, vec3(10, 10, 10)), float(iterations));
}

///////////////
// Scene SDF //
///////////////

vec2 scene_sdf(vec3 p, out vec3 z) {
	vec2 data;
	if (formula == 1) data = mandelbulb_sdf(p, z);
	else if (formula == 2) data = juliabulb_sdf(p, z);
	else if (formula == 3) data = burning_ship_sdf(p, z);
	else if (formula == 4) data = mandelbox_sdf(p / size);
	
	return vec2(data.y, data.x);
}
