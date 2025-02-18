float sphereFold(vec4 z, float minR, float maxR, float bloatFactor) { float r2 = dot(z.xyz, z.xyz); return max(maxR / max(minR, r2), bloatFactor); }
vec4 boxFold(vec4 z, vec3 r) { z.xyz = clamp(z.xyz, -r, r) * 2.0 - z.xyz; return z; }
float de_box(vec4 p, vec3 s) { vec3 a = abs(p.xyz) - s; return (min(max(max(a.x, a.y), a.z), 0.0) + length(max(a, 0.0))) / p.w; }

vec2 mandelbox_sdf(vec3 pos, float power) {
	vec4 p = vec4(pos, 1.0) * 4.0;
	vec4 o = p;
	float orbit_trap = 100000000.0;

	for (int i = 0; i < iterations; i++) {
		p = boxFold(p, fmandelbox_box_size);
		p *= sphereFold(p, fmandelbox_sphere_fold.x, fmandelbox_sphere_fold.y, fmandelbox_sphere_fold.z) * (power + 0.181);
		p += o * fmandelbox_spread;
		p += sin(o) * fmandelbox_stoneness;
		p += sin(o - p) * fmandelbox_divisions;
		p += vec4(sphereInversion(p.xyz, fmandelbox_sphere_reflection_position, fmandelbox_sphere_reflection), 0.0);

		if (coloring_mode == 0) orbit_trap = min(orbit_trap, length(p));
		else orbit_trap = min(orbit_trap, process_orbit_trap4d(p));
	}

	return vec2(de_box(p, vec3(10, 10, 10)), orbit_trap);
}