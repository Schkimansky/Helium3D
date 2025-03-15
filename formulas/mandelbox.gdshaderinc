// [ID]
// mandelbox
// [INDEX]
// 2
// [VARS]
// vec3 sphere_fold[(0, 0, 0), (2, 2, 2)] = (0.0, 1.0, 1.0)
// vec3 box_size[(0, 0, 0), (2, 2, 2)] = (1.0, 1.0, 1.0)
// float sphere_reflection[0.0, 1.5] = 0.0
// float spread[0.0, 2.0] = 1.0
// [CODE]
uniform vec3 fmandelbox_sphere_fold;
uniform vec3 fmandelbox_box_size;
uniform float fmandelbox_sphere_reflection;
uniform float fmandelbox_spread;

float sphereFold(vec4 z, float minR, float maxR, float bloatFactor) {
	float r2 = dot(z.xyz, z.xyz);
	return max(maxR / max(minR, r2), bloatFactor);
}

float de_box(vec4 p, vec3 s) { vec3 a = abs(p.xyz) - s; return (min(max(max(a.x, a.y), a.z), 0.0) + length(max(a, 0.0))) / p.w; }

vec2 mandelbox_sdf(vec3 pos, float power) {
	vec4 p = vec4(pos, 1.0) * 4.0;
	vec4 o = p;
	float orbit_trap = 100000000.0;

	for (int i = 0; i < iterations; i++) {
		p.xyz = clamp(p.xyz, -fmandelbox_box_size, fmandelbox_box_size) * 2.0 - p.xyz;
		p *= sphereFold(p, fmandelbox_sphere_fold.x, fmandelbox_sphere_fold.y, fmandelbox_sphere_fold.z) * (power + 0.181);
		p += o * fmandelbox_spread;
		//p += sin(o) * fmandelbox_stoneness;
		//p += sin(o - p) * fmandelbox_divisions;
		p.xyz += sphereInversion(p.xyz, vec3(0.0), fmandelbox_sphere_reflection);

		if (coloring_mode == 0) orbit_trap = min(orbit_trap, length(p));
		else orbit_trap = min(orbit_trap, process_orbit_trap4d(p));
	}

	return vec2(de_box(p, vec3(10, 10, 10)), orbit_trap);
}