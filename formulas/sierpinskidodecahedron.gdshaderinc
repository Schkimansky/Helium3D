// [ID]
// sierpinskidodecahedron
// [INDEX]
// 9
// [VARS]
// vec3 offset[(-1, -1, -1), (1, 1, 1)] = (1, 1, 1)
// vec3 rotation1[(-3.14159, -3.14159, -3.14159), (3.14159, 3.14159, 3.14159)] = (0, 0, 0)
// vec3 rotation2[(-3.14159, -3.14159, -3.14159), (3.14159, 3.14159, 3.14159)] = (0, 0, 0)
// [CODE]
uniform vec3 fsierpinskidodecahedron_rotation1;
uniform vec3 fsierpinskidodecahedron_rotation2;
uniform vec3 fsierpinskidodecahedron_offset;

vec2 sierpinskidodecahedron_sdf(vec3 z, float scale) {
	scale += 1.0;

	vec3 n1 = normalize(vec3(-1.0, golden_ratio - 1.0, 1.0 / (golden_ratio - 1.0)));
	vec3 n2 = normalize(vec3(golden_ratio - 1.0, 1.0 / (golden_ratio - 1.0), -1.0));
	vec3 n3 = normalize(vec3(1.0 / (golden_ratio - 1.0), -1.0, golden_ratio - 1.0));
	vec3 offset = fsierpinskidodecahedron_offset;
	float orbit_trap = 100000.0;
	float s = 1.0;
	float r;
	int n = 0;

	for (; n < iterations; n++) {
		//z -= 2.0 * min(0.0, dot(z, n1)) * n1;
		//z -= 2.0 * min(0.0, dot(z, n2)) * n2;
		//z -= 2.0 * min(0.0, dot(z, n3)) * n3;
		z = rotate3d_point(z, fsierpinskidodecahedron_rotation1);

		z -= 2.0 * min(0.0, dot(z, n1)) * n1;
		z -= 2.0 * min(0.0, dot(z, n2)) * n2;
		z -= 2.0 * min(0.0, dot(z, n3)) * n3;
		z -= 2.0 * min(0.0, dot(z, n1)) * n1;
		z -= 2.0 * min(0.0, dot(z, n2)) * n2;
		z -= 2.0 * min(0.0, dot(z, n3)) * n3;
		z -= 2.0 * min(0.0, dot(z, n1)) * n1;
		z -= 2.0 * min(0.0, dot(z, n2)) * n2;
		z -= 2.0 * min(0.0, dot(z, n3)) * n3;

		z = z * scale - offset * (scale - 1.0);
		s /= scale;

		z = rotate3d_point(z, fsierpinskidodecahedron_rotation2);

		r = dot(z, z);
		if (coloring_mode == 0) orbit_trap = min(orbit_trap, abs(r));
		else orbit_trap = min(orbit_trap, process_orbit_trap(z));
		if (r > 1e6) break;
	}
	
	// float d = 0.99 * length(z) * pow(scale, float(-n - 1));
	float d = dodecahedron_sdf3d(z, 1.0) * s;
	return vec2(d, orbit_trap);
}