// [ID]
// sierpinskioctahedron
// [INDEX]
// 8
// [VARS]
// [CODE]
uniform vec4 fsierpinskioctahedron_rotation = vec4(0.0, 0.0, 0.0, 0.0);
uniform vec3 fsierpinskioctahedron_offset = vec3(0.0, 0.0, 0.0);
uniform int fsierpinskioctahedron_fold_mode = 0;

vec2 sierpinskioctahedron_sdf(vec3 z, float scale) {
	vec3 offset = fsierpinskioctahedron_offset;
	float orbit_trap = 100000.0;
	float r;
	int n = 0;

	while (n < iterations) {
		z.xz = vec2(cos(fsierpinskioctahedron_rotation.x) * z.x - sin(fsierpinskioctahedron_rotation.x) * z.z, sin(fsierpinskioctahedron_rotation.x) * z.x + cos(fsierpinskioctahedron_rotation.x) * z.z);
		z.yz = vec2(cos(fsierpinskioctahedron_rotation.y) * z.y - sin(fsierpinskioctahedron_rotation.y) * z.z, sin(fsierpinskioctahedron_rotation.y) * z.y + cos(fsierpinskioctahedron_rotation.y) * z.z);

		z = abs(z);
		if (fsierpinskioctahedron_fold_mode == 0) {
			if (z.x + z.y < 0.0) z.xy = -z.yx;
			if (z.x + z.z < 0.0) z.xz = -z.zx;
			if (z.x - z.y < 0.0) z.xy = z.yx;
			if (z.x - z.z < 0.0) z.xz = z.zx;
		} else if (fsierpinskioctahedron_fold_mode == 1) {
			if (z.x + z.y < 0.0) z.xy = -z.yx;
			if (z.x + z.z < 0.0) z.xz = -z.zx;
			if (z.x - z.y < 0.0) z.xy = z.yx;
			if (z.x - z.z < 0.0) z.xz = z.zx;
			if (z.z < z.x) z.zx = z.xz;
		} else if (fsierpinskioctahedron_fold_mode == 2) {
			if (z.x + z.y < 0.0) z.xy = -z.yx;
			if (z.x + z.z < 0.0) z.xz = -z.zx;
			if (z.x - z.y < 0.0) z.xy = z.yx;
			if (z.z < z.x) z.zx = z.xz;
		} else if (fsierpinskioctahedron_fold_mode == 3) {
			if (z.x + z.y < 0.0) z.xy = -z.yx;
			if (z.x + z.z < 0.0) z.xz = -z.zx;
			//if (z.x - z.y < 0.0) z.xy = z.yx;
			if (z.x - z.z < 0.0) z.xz = z.zx;
			if (z.z < z.x) z.zx = z.xz;
		} else if (fsierpinskioctahedron_fold_mode == 4) {
			if (z.x + z.y < 0.0) z.xy = -z.yx;
			//if (z.x + z.z < 0.0) z.xz = -z.zx;
			if (z.x - z.y < 0.0) z.xy = z.yx;
			if (z.x - z.z < 0.0) z.xz = z.zx;
			if (z.z < z.x) z.zx = z.xz;
		}
		z = z * scale - offset * (scale - 1.0);

		z.xz = vec2(cos(fsierpinskioctahedron_rotation.z) * z.x - sin(fsierpinskioctahedron_rotation.z) * z.z, sin(fsierpinskioctahedron_rotation.z) * z.x + cos(fsierpinskioctahedron_rotation.z) * z.z);
		z.yz = vec2(cos(fsierpinskioctahedron_rotation.w) * z.y - sin(fsierpinskioctahedron_rotation.w) * z.z, sin(fsierpinskioctahedron_rotation.w) * z.y + cos(fsierpinskioctahedron_rotation.w) * z.z);

		r = dot(z, z);
		if (coloring_mode == 0) orbit_trap = min(orbit_trap, abs(r));
		else orbit_trap = min(orbit_trap, process_orbit_trap(z));
		n++;
	}

	return vec2(length(z) * pow(scale, float(-n)), orbit_trap);
}
