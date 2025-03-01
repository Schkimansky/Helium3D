// [ID]
// mengersponge
// [INDEX]
// 7
// [VARS]
// vec3 offset[(0, 0, 0), (2.5, 2.5, 2.5)] = (1, 1, 1)
// vec3 rotation1[(-2, -2, -2), (2, 2, 2)] = (0.0, 0.0, 0.0)
// vec3 rotation2[(-2, -2, -2), (2, 2, 2)] = (0.0, 0.0, 0.0)
// [CODE]
uniform vec3 fmengersponge_rotation1;
uniform vec3 fmengersponge_rotation2;
uniform vec3 fmengersponge_offset;

vec2 mengersponge_sdf(vec3 p, float power) {
    float scale = power + 1.0;
    float colorind = 0.0;
	float orbit_trap = 1000000.0;
	int n = 0;

	for (; n < iterations; n++) {
		p = rotate3d_point(p, fmengersponge_rotation1);

		p = abs(p);
		if (p.y > p.x) p.yx = p.xy;
		if (p.z > p.y) p.zy = p.yz;

		if (coloring_mode == 0) orbit_trap = min(orbit_trap, abs(dot(p, p)));
		else orbit_trap = min(orbit_trap, process_orbit_trap(p));

		p *= scale;
		if (p.z > 0.5 * (scale - 1.0)) {
			//p -= (vec3(1) * (1.0 / power)) * (scale - 1.0);
			p -= fmengersponge_offset * (scale - 1.0);
		} else {
			//p -= (vec3(1.0, 1.0, 0.0) * (1.0 / power)) * (scale - 1.0);
			//p -= vec3(1, 1, 1) * (scale - 1.0);
			p -= (fmengersponge_offset * vec3(1, 1, 0)) * (scale - 1.0);
		}

		p = rotate3d_point(p, fmengersponge_rotation2);
	}

	float d = length(p) * pow(scale, -float(n));
	return vec2(d, orbit_trap);
}