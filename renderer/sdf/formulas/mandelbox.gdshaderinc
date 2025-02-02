float sphereFold(vec4 z, float minR, float maxR, float bloatFactor) { float r2 = dot(z.xyz, z.xyz); return max(maxR / max(minR, r2), bloatFactor); }
void boxFold(inout vec4 z, vec3 r) { z.xyz = clamp(z.xyz, -r, r) * 2.0 - z.xyz; }
float de_box(vec4 p, vec3 s) { vec3 a = abs(p.xyz) - s; return (min(max(max(a.x, a.y), a.z), 0.0) + length(max(a, 0.0))) / p.w; }

vec2 mandelbox_sdf(vec3 pos, float power) {
	vec4 p = vec4(pos, 1.0);
	p *= 4.0;
	vec4 o = p;
	float min_dist = 100000000.0;

	for (int i = 0; i < iterations; i++) {
		boxFold(p, fmandelbox_box_size);
		p *= sphereFold(p, fmandelbox_sphere_fold.x, fmandelbox_sphere_fold.y, fmandelbox_sphere_fold.z) * power;
		p += o * fmandelbox_spread;
		p += sin(o) * fmandelbox_stoneness;
		p += sin(o - p) * fmandelbox_divisions;
		p += vec4(sphereInversion(p.xyz, fmandelbox_sphere_reflection_position, fmandelbox_sphere_reflection), 0.0);

		min_dist = min(min_dist, sphere_sdf4d(p, vec4(0.0, 0.0, 0.0, 0.0), 0.0));
	}

	return vec2(de_box(p, vec3(10, 10, 10)), float(min_dist));
}