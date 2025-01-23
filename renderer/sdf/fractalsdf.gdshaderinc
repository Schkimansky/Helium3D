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

#include "formulae/mandelbulb.gdshaderinc"

//vec3 iterate(vec3 z, vec3 p) {
	//if (formula == 1) return fmandelbulb(z, p, power);
	//if (formula == 2) return fjuliabulb(p, fjuliabulb_c, power);
	//if (formula == 3) return flogz(z, p, power);
//}

//vec2 fractal_sdf(vec3 p, out vec3 final_z) {
	//vec3 z = vec3(0.0, 0.0, 0.0);
	//float r = length(z);
	//float dz = 1.0;
	//
	//for (int i = 0; i < iterations; i++) {
		//z = iterate(z, p);
		//
		//r = length(z);
		//dz = power * pow(r, power - 1.0) * dz + 1.0;
		//
		//if (r >= escape_radius) {
			//final_z = z;
			//return vec2(0.8 * log(r) * sqrt(r) / dz, float(i));
		//};
	//}
	//
	//final_z = z;
	//return vec2(0.8 * log(r) * sqrt(r) / dz, float(iterations));
//}

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

vec2 mandleBox(vec3 pos) {
    vec4 p = vec4(pos, 1);
    p *= 4.;
    vec4 o = p;
    for (int i = 0; i < iterations; ++i) {
		boxFold(p, vec3(1.0, 1.0, 1.0));
		p *= sphereFold(p, 0.0, 1.0, 1.0) * power;
		p += o;
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
	else if (formula == 4) data = mandleBox(p / size);
	float signed_distance = data.x;
	float iterations_to_escape = data.y;

	return vec2(iterations_to_escape, signed_distance);
}
