//vec2 mengersponge_sdf(vec3 p, float power){
	//float d = cube_sdf3d(p, vec3(1));
	//float res = d;
	//float s = 1.0;
//
	//for (int m = 0; m < iterations; m++) {
		//vec3 a = mod(p * s, 2.0) - 1.0;
		//s *= power + 1.0;
		//vec3 r = abs(1.0 - (power + 1.0) * abs(a));
//
		//float da = max(r.x, r.y);
		//float db = max(r.y, r.z);
		//float dc = max(r.z, r.x);
		//float c = (min(da, min(db, dc)) - 1.0) / s;
//
		//if (c > d) {
			//d = c;
			//res = c;
		//}
	//}
	//return vec2(res, 0.0);
//}

vec2 mengersponge_sdf(vec3 p, float power) {
    float scale = power + 1.0;
    float colorind = 0.0;
    float alpha = fmengersponge_rotation_x;
    float beta = fmengersponge_rotation_y;
	int n = 0;
    for (; n < iterations; n++) {
        // Apply rotations
        p.xz = vec2(cos(alpha) * p.x - sin(alpha) * p.z, sin(alpha) * p.x + cos(alpha) * p.z); // Y-axis rotation
        p.yz = vec2(cos(beta) * p.y - sin(beta) * p.z, sin(beta) * p.y + cos(beta) * p.z);     // X-axis rotation

        p = abs(p);
        if (p.y > p.x) p.yx = p.xy;
        if (p.z > p.y) p.zy = p.yz;

        p *= scale;
        if (p.z > 0.5 * (scale - 1.0)) {
            p -= vec3(1) * (scale - 1.0);
            colorind++;
        } else {
            p -= vec3(1, 1, 0) * (scale - 1.0);
        }
    }
	// Multiply by 0.715 because of bad distance estimation
    float d = 0.715 * length(p) * pow(scale, -float(n));
    return vec2(d, colorind);
}