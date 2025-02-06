
vec2 pseudoklenian_sdf(vec3 pos, float power) {
    vec3 p = pos;
	vec3 q = pos;
    float fractal_scale = 1.0;
    float orbit_trap = 100000.0;
	float alpha = ftetraglad_rotation_x;
	float beta = ftetraglad_rotation_y;

    for(int i = 0; i < iterations; ++i) {
		//p *= max_radius / dot(p, p);

        // Folding operations
        //p = 2.0 * clamp(p, fpseudoklenian_min.xyz, fpseudoklenian_max.xyz) - p;
		if (fpseudoklenian_mode == 1) q = 2.0 * clamp(q, fpseudoklenian_min.xyz, fpseudoklenian_max.xyz) - q;
		else if (fpseudoklenian_mode == 2) q = 2.0 * fract(0.5 * q + 0.5) - 1.0;
		//float angle = radians(10.0); // Rotate by 45 degrees
		//mat2 rot = mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
		////p.xy = rot * p.xy;
		//q.xy = rot * q.xy;
		//p += fpseudoklenian_pc;

		q.xz = vec2(cos(alpha) * q.x - sin(alpha) * q.z, sin(alpha) * q.x + cos(alpha) * q.z); // Y-axis rotation
		q.yz = vec2(cos(beta) * q.y - sin(beta) * q.z, sin(beta) * q.y + cos(beta) * q.z);     // X-axis rotation

        // Scaling factors
		// + (cos(q) * fpseudoklenian_cosine_multiplier)
		//  + ((sin(length(q.xz * q.yx) * 5.0) * fpseudoklenian_cosine_multiplier)
		float rp2 = (dot(q, q) * (power - 0.772));
		float k1 = max(fpseudoklenian_min.w / rp2, 1.0);
		q *= k1;
		fractal_scale *= k1;

		orbit_trap = min(orbit_trap, dot(q, q));
	}

	// Calculate final distance
    float lxy = length(q.xy);
    float d = 0.5 * max(fpseudoklenian_max.w - lxy, lxy * q.z / length(q)) / fractal_scale;
    return vec2(d, orbit_trap);
}

