vec2 pseudoklenian_sdf(vec3 pos) {
    vec3 p = pos;
    vec3 q = pos;
    float scale = 1.0;
    float orbit_trap = 1e4;

    for(int i = 0; i < iterations; ++i) { // Max 20 iterations, adjust as needed
		if (i >= 3) break;
        p = 2.0 * clamp(p, fpseudoklenian_min.xyz, fpseudoklenian_max.xyz) - p;
        q = 2.0 * fract(0.5 * q + 0.5) - 1.0;

        // Scaling factors
        float rp2 = dot(p, p);
        float rq2 = dot(q, q);
        float k1 = max(fpseudoklenian_min.w / rp2, 1.0);
        float k2 = max(fpseudoklenian_min.w / rq2, 1.0);

        // Apply scaling
        p *= k1;
        q *= k2;
        scale *= k1;

        // Update orbit trap for coloring
        orbit_trap = min(orbit_trap, dot(p, p));
    }

    // Calculate final distance
    float lxy = length(p.xy);
    float d = 0.5 * max(fpseudoklenian_max.w - lxy, lxy * p.z / length(p)) / scale;
    return vec2(0.0, 0.0);
}