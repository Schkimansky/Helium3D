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

// 0 = Mandelbulb, 1 = Juliabulb, 2 = Burning ship
vec2 mandelfractal(int fractal_id, vec3 p) {
	vec3 scaled_p = p;
	vec3 z;
	vec3 c;
	if (fractal_id == 1 || fractal_id == 3) { z = vec3(0.00001, 0.0, 0.0); c = scaled_p; } 
	else { z = scaled_p; c = fjuliabulb_c; }
	
	float min_dist = 10000000.0;
	float r = length(z);
	float dz = 1.0;
	float powercache1 = (power - 1.0) * 0.5;
	
	for (int i = 0; i < int(iterations); i++) {
		dz = power * pow(r, powercache1) * dz + 1.0;
		float th = power * fast_acos(z.z / r);
		float ph = power * atan(z.y, z.x);
		if (fractal_id == 3) z = abs(z);
		
		z = complexPow(z, power);
		z += c;
		
		r = length(z);
		float new_dist = distance(z, vec3(0.0, 0.0, 0.0));
		if (new_dist < min_dist) min_dist = new_dist;
		
		if (r > escape_radius) break;
	}
	
	return vec2(0.5 * log(r) * sqrt(r) / dz, min_dist);
}

///////////////
// Mandelbox //
///////////////

// Some algorithms
float sphereFold(vec4 z, float minR, float maxR, float bloatFactor) { float r2 = dot(z.xyz, z.xyz); return max(maxR / max(minR, r2), bloatFactor); }
void boxFold(inout vec4 z, vec3 r) { z.xyz = clamp(z.xyz, -r, r) * 2.0 - z.xyz; }
float de_box(vec4 p, vec3 s) { vec3 a = abs(p.xyz) - s; return (min(max(max(a.x, a.y), a.z), 0.0) + length(max(a, 0.0))) / p.w; }

vec2 mandelbox_sdf(vec3 pos) {
	vec4 p = vec4(pos, 1);
	p *= 4.0;
	vec4 o = p;
	float min_dist = 100000000.0;
	
	for (int i = 0; i < iterations; i++) {
		boxFold(p, fmandelbox_box_size);
		p *= sphereFold(p, fmandelbox_sphere_fold.x, fmandelbox_sphere_fold.y, fmandelbox_sphere_fold.z) * power;
		p += o * fmandelbox_spread;
		p += sin(o) * fmandelbox_stoneness;
		p += sin(o - p) * fmandelbox_divisions;
		
		if (distance(p, vec4(0.0, 0.0, 0.0, 0.0)) < min_dist) min_dist = distance(p, vec4(0.0, 0.0, 0.0, 0.0));
	}
	
	return vec2(de_box(p, vec3(10, 10, 10)), float(min_dist));
}

///////////////
// Scene SDF //
///////////////

vec2 scene_sdf(vec3 p) {
	vec2 data;
	if (formula == 1 || formula == 2 || formula == 3) data = mandelfractal(formula, p);
	else if (formula == 4) data = mandelbox_sdf(p);
	
	return vec2(data.y, data.x);
}
