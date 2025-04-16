// [ID]
// mandelbulb
// [INDEX]
// 1
// [VARS]
// selection variant[Mandelbulb, Burning Ship, Sine Wave, Folded, Hybrid Rotation, Mandelbox, Quaternion, Sierpinski] = Mandelbulb
// float zmul[-2, 2] = -1
// float phase[0.0, 30.0] = 11.0
// float pheonix[0.0, 1.5] = 0.0
// float power[2.0, 16.0] = 8.0
// float derivative_bias[0.0, 2.0] = 1.0
// float pheonix[0.0, 1.5] = 0.0
// bool is_julia[false, true] = false
// vec3 julia_c[(-3, -3, -3), (3, 3, 3)] = (1.3, 1.3, 1.3)
// [CODE]

uniform float fmandelbulb_derivative_bias;
uniform float fmandelbulb_power;
uniform int fmandelbulb_variant;
uniform float fmandelbulb_phase;
uniform float fmandelbulb_pheonix;
uniform float fmandelbulb_zmul;
uniform bool fmandelbulb_is_4d;
uniform bool fmandelbulb_is_julia;
uniform vec3 fmandelbulb_julia_c;

vec2 mandelbulb_sdf(vec3 p) {
	vec3 c = p;
	vec3 z = p;
	float orbit_trap = 10000000.0;
	float r = length(z);
	float dz = 1.0;
	float power = fmandelbulb_power;

	for (int i = 0; i < int(iterations); i++) {
		r = length(z);
		if (r > escape_radius) break;

		dz = max(dz * fmandelbulb_derivative_bias, pow(r, power - 1.0) * dz * power + 1.0);
		z = triplex_pow(z, power, fmandelbulb_phase, fmandelbulb_zmul) + c;

		if (coloring_mode == 0) orbit_trap = min(orbit_trap, dot(z, z));
		else orbit_trap = min(orbit_trap, process_orbit_trap(z));
	}

	return vec2(0.5 * log(r) * r / dz, orbit_trap);
}