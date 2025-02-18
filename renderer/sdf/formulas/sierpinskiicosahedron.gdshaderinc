
vec2 sierpinskiicosahedron_sdf(vec3 z, float scale) {
	vec3 n1 = normalize(vec3(-golden_ratio, golden_ratio - 1.0, 1.0));
	vec3 n2 = normalize(vec3(1.0, -golden_ratio, golden_ratio + 1.0));
	vec3 n3 = normalize(vec3(0.0, 0.0, -1.0));
	vec3 offset = fsierpinskiicosahedron_offset;
	float orbit_trap = 100000.0;
	float r;
	float t;
	int n = 0;

	z = abs(z);
	t = dot(z, n1); if (t > 0.0) z -= 2.0 * t * n1;
	t = dot(z, n2); if (t > 0.0) z -= 2.0 * t * n2;
	t = dot(z, n3); if (t > 0.0) z -= 2.0 * t * n3;
	t = dot(z, n2); if (t > 0.0) z -= 2.0 * t * n2;

	for (; n < iterations; n++) {
		z.xz = vec2(cos(fsierpinskiicosahedron_rotation.x) * z.x - sin(fsierpinskiicosahedron_rotation.x) * z.z, sin(fsierpinskiicosahedron_rotation.x) * z.x + cos(fsierpinskiicosahedron_rotation.x) * z.z);
		z.yz = vec2(cos(fsierpinskiicosahedron_rotation.y) * z.y - sin(fsierpinskiicosahedron_rotation.y) * z.z, sin(fsierpinskiicosahedron_rotation.y) * z.y + cos(fsierpinskiicosahedron_rotation.y) * z.z);

		z = abs(z);
		t = dot(z, n1); if (t > 0.0) z -= 2.0 * t * n1;
		z = scale * z - offset * (scale - 1.0);

		z.xz = vec2(cos(fsierpinskiicosahedron_rotation.z) * z.x - sin(fsierpinskiicosahedron_rotation.z) * z.z, sin(fsierpinskiicosahedron_rotation.z) * z.x + cos(fsierpinskiicosahedron_rotation.z) * z.z);
		z.yz = vec2(cos(fsierpinskiicosahedron_rotation.w) * z.y - sin(fsierpinskiicosahedron_rotation.w) * z.z, sin(fsierpinskiicosahedron_rotation.w) * z.y + cos(fsierpinskiicosahedron_rotation.w) * z.z);

		r = dot(z, z);
		if (coloring_mode == 0) orbit_trap = min(orbit_trap, abs(r));
		else orbit_trap = min(orbit_trap, process_orbit_trap(z));
		if (r > 1e6) break;
	}

	return vec2(length(z) * pow(scale, float(-n - 1)), orbit_trap);
}