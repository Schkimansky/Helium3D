// [ID]
// mandelbox
// [INDEX]
// 2
// [VARS]
// vec3 sphere_fold[(0, 0, 0), (2, 2, 2)] = (0.0, 1.0, 1.0)
// vec3 box_size[(0, 0, 0), (2, 2, 2)] = (1.0, 1.0, 1.0)
// float sphere_reflection[0.0, 1.5] = 0.0
// float spread[0.0, 2.0] = 1.0
// float stoneness[0.0, 2.0] = 0.0
// float divisions[0.0, 2.0] = 0.0
// vec3 sphere_reflection_position[(-2, -2, -2), (2, 2, 2)] = (0.0, 0.0, 0.0)

// [CODE]
uniform vec3 fmandelbox_sphere_fold;
uniform vec3 fmandelbox_box_size;
uniform float fmandelbox_sphere_reflection;
uniform float fmandelbox_spread;
uniform float fmandelbox_stoneness;
uniform float fmandelbox_divisions;
uniform vec3 fmandelbox_sphere_reflection_position;

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