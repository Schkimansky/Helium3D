// [ID]
// pseudoklenian
// [INDEX]
// 10
// [VARS]
// vec4 min[(-2, -2, -2, -2), (2, 2, 2, 2)] = (-0.8323, -0.694, -0.5045, 2)
// vec4 max[(-2, -2, -2, -2), (2, 2, 2, 2)] = (1, 1, 1, 1.316)
// vec4 inversion_sphere[(-2, -2, -2, -2), (2, 2, 2, 2)] = (1.0, 1.0, 1.0, 1.0)
// float sign[0.0, 0.2] = 0.0
// bool invert[false, true] = false
// [CODE]
uniform vec4 fpseudoklenian_min;
uniform vec4 fpseudoklenian_max;
uniform vec4 fpseudoklenian_inversion_sphere;
uniform bool fpseudoklenian_invert;
uniform float fpseudoklenian_sign;

vec3 invertSphere(vec3 point, vec4 sph) {
	vec3 diff = point - sph.xyz;
	float length_squared = length(diff) * length(diff);
	float scale = sph.w * sph.w / length_squared;
	return diff * scale + sph.xyz;
}

vec2 pseudoklenian_sdf(vec3 pos, float power) {
	if (fpseudoklenian_invert) {
		pos = invertSphere(pos, fpseudoklenian_inversion_sphere);
	}

	vec3 p = pos;
	vec3 q = pos;
	float fractal_scale = 1.0;
	float orbit_trap = 100000.0;
	//float alpha = fpseudoklenian_rotation_x;
	//float beta = fpseudoklenian_rotation_y;
	//float symmetry = fpseudoklenian_symmetry;

	for (int i = 0; i < iterations; ++i) {
		q = 2.0 * clamp(q, fpseudoklenian_min.xyz, fpseudoklenian_max.xyz) - q;
		q -= sign(q) * fpseudoklenian_sign;

		float rp2 = dot(q, q) * (power - 0.772);
		float k1 = max(fpseudoklenian_min.w / rp2, 1.0);
		q *= k1;
		fractal_scale *= k1;

		if (coloring_mode == 0) orbit_trap = min(orbit_trap, dot(q, q));
		else orbit_trap = min(orbit_trap, process_orbit_trap(q));
	}

	float lxy = length(q.xy);
	float d = 0.5 * max(fpseudoklenian_max.w - lxy, lxy * q.z / length(q)) / fractal_scale;
	return vec2(0.5 * d, orbit_trap);
}
