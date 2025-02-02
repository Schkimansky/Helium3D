vec2 mengersponge_sdf(vec3 p, float power){
	float d = cube_sdf3d(p, vec3(1));
	float res = d;
	float s = 1.0;
	for (int m = 0; m < iterations; m++) {
		vec3 a = mod(p * s, 2.0) - 1.0;
		s *= power + 1.0;
		vec3 r = abs(1.0 - (power + 1.0) * abs(a));

		float da = max(r.x, r.y);
		float db = max(r.y, r.z);
		float dc = max(r.z, r.x);
		float c = (min(da, min(db, dc)) - 1.0) / s;

		if (c > d) {
			d = c;
			res = c;
		}
	}
	return vec2(res, 0.0);
}
