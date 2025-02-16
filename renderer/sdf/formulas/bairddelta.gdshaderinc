
vec2 bairddelta_sdf(vec3 p, float power) {
	float angle = clamp(fbairddelta_angle, 60.0001, 90.0);
	float beta = (PI / 360.0) * angle;
	float t = tan(beta);
	vec3 n1 = vec3(cos(PI / 6.0), -sin(PI / 6.0), 0.0);
	vec3 n2 = vec3(0.5, 0.0, sqrt(3.0 * t * t - 1.0) * 0.25);
	vec3 n3 = normalize(vec3(1.0, 0.0, -0.5 * sqrt(3.0 * t * t - 1.0)));
	t = cos(beta);
	float scale = power * 2.0 * t * t;
	float orbit_trap = 10000.0;

	float r2 = dot(p, p);
	float dd = 1.0;
	for (int i = 0; i < iterations; i++) {
		p.xz = vec2(cos(fbairddelta_rotation.x) * p.x - sin(fbairddelta_rotation.x) * p.z, sin(fbairddelta_rotation.x) * p.x + cos(fbairddelta_rotation.x) * p.z);
		p.yz = vec2(cos(fbairddelta_rotation.y) * p.y - sin(fbairddelta_rotation.y) * p.z, sin(fbairddelta_rotation.y) * p.y + cos(fbairddelta_rotation.y) * p.z);

		// Sierpinski triangle symmetry + fold about xy plane
		p.yz = abs(p.yz);
		float t = fbairddelta_folds.z * min(0.0, dot(p, n1));
		p -= t * n1;
		p.y = abs(p.y);

		// Koch curve fold
		p -= n2;
		t = fbairddelta_folds.w * min(0.0, dot(p, n3));
		p -= t * n3;
		p += n2;

		// Scale and rotate
		p.x -= fbairddelta_folds.x;
		p *= scale;
		p.x += fbairddelta_folds.y;
		dd *= scale;

		p.xz = vec2(cos(fbairddelta_rotation.z) * p.x - sin(fbairddelta_rotation.z) * p.z, sin(fbairddelta_rotation.z) * p.x + cos(fbairddelta_rotation.z) * p.z);
		p.yz = vec2(cos(fbairddelta_rotation.w) * p.y - sin(fbairddelta_rotation.w) * p.z, sin(fbairddelta_rotation.w) * p.y + cos(fbairddelta_rotation.w) * p.z);

		r2 = dot(p, p);
		orbit_trap = min(orbit_trap, abs(r2));
	}
	return vec2((sqrt(r2) - 3.0) / dd, orbit_trap);
}
