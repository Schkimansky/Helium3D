// [ID]
// sierpinskidodecahedron
// [INDEX]
// 9
// [VARS]
// vec3 offset[(-1, -1, -1), (1, 1, 1)] = (1, 1, 1)
// vec4 rotation[(-2, -2, -2, -2), (2, 2, 2, 2)] = (0, 0, 0, 0)
// vec3 cscale[(-2, -2, -2, -2), (2, 2, 2, 2)] = (1, 1, 1, 1)
// [CODE]
uniform vec4 fsierpinskidodecahedron_rotation = vec4(0.0, 0.0, 0.0, 0.0);
uniform vec3 fsierpinskidodecahedron_offset = vec3(0.0, 0.0, 0.0);
uniform vec3 fsierpinskidodecahedron_cscale = vec3(1.0, 1.5, 1.0);

vec2 sierpinskidodecahedron_sdf(vec3 z, float scale) {
	scale += 1.0;

	vec3 n1 = normalize(vec3(-1.0, golden_ratio - 1.0, 1.0 / (golden_ratio - 1.0)));
	vec3 n2 = normalize(vec3(golden_ratio - 1.0, 1.0 / (golden_ratio - 1.0), -1.0));
	vec3 n3 = normalize(vec3(1.0 / (golden_ratio - 1.0), -1.0, golden_ratio - 1.0));
	vec3 offset = fsierpinskidodecahedron_offset;
	float orbit_trap = 100000.0;
	float r;
	int n = 0;

	for (; n < iterations; n++) {
		//z -= 2.0 * min(0.0, dot(z, n1)) * n1;
		//z -= 2.0 * min(0.0, dot(z, n2)) * n2;
		//z -= 2.0 * min(0.0, dot(z, n3)) * n3;

		z.xz = vec2(cos(fsierpinskidodecahedron_rotation.x) * z.x - sin(fsierpinskidodecahedron_rotation.x) * z.z, sin(fsierpinskidodecahedron_rotation.x) * z.x + cos(fsierpinskidodecahedron_rotation.x) * z.z);
		z.yz = vec2(cos(fsierpinskidodecahedron_rotation.y) * z.y - sin(fsierpinskidodecahedron_rotation.y) * z.z, sin(fsierpinskidodecahedron_rotation.y) * z.y + cos(fsierpinskidodecahedron_rotation.y) * z.z);

		z -= 2.0 * min(0.0, dot(z, n1)) * n1;
		z -= 2.0 * min(0.0, dot(z, n2)) * n2;
		z -= 2.0 * min(0.0, dot(z, n3)) * n3;
		z -= 2.0 * min(0.0, dot(z, n1)) * n1;
		z -= 2.0 * min(0.0, dot(z, n2)) * n2;
		z -= 2.0 * min(0.0, dot(z, n3)) * n3;
		z -= 2.0 * min(0.0, dot(z, n1)) * n1;
		z -= 2.0 * min(0.0, dot(z, n2)) * n2;
		z -= 2.0 * min(0.0, dot(z, n3)) * n3;

		z = z * scale - offset * fsierpinskidodecahedron_cscale * (scale - 1.0);

		z.xz = vec2(cos(fsierpinskidodecahedron_rotation.z) * z.x - sin(fsierpinskidodecahedron_rotation.z) * z.z, sin(fsierpinskidodecahedron_rotation.z) * z.x + cos(fsierpinskidodecahedron_rotation.z) * z.z);
		z.yz = vec2(cos(fsierpinskidodecahedron_rotation.w) * z.y - sin(fsierpinskidodecahedron_rotation.w) * z.z, sin(fsierpinskidodecahedron_rotation.w) * z.y + cos(fsierpinskidodecahedron_rotation.w) * z.z);

		r = dot(z, z);
		if (coloring_mode == 0) orbit_trap = min(orbit_trap, abs(r));
		else orbit_trap = min(orbit_trap, process_orbit_trap(z));
		if (r > 1e6) break;
	}

	return vec2(0.99 * length(z) * pow(scale, float(-n - 1)), orbit_trap);
}