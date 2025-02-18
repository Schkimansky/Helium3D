mat3 rotX(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat3(
        vec3(1, 0, 0),
        vec3(0, c, s),
        vec3(0,-s, c)
    );
}

mat3 rotY(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat3(
        vec3(c, 0,-s),
        vec3(0, 1, 0),
        vec3(s, 0, c)
    );
}

mat3 rotZ(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat3(
        vec3(c, s, 0),
        vec3(-s, c, 0),
        vec3(0, 0, 1)
    );
}

vec2 mengerflake_sdf(vec3 p, float power) {
	p = abs(p);
	p *= rotX(fmengerflake_rotation_x) * rotY(fmengerflake_rotation_y);
	p -= vec3(0, fmengerflake_offset, 0);
	//p -= vec3(0, power, 0);
	float orbit_trap = 100000.0;
	float w = 0.866;

	for (int i = 0; i < iterations; i++) {
		p = abs(p);
		p.xz -= vec2(w);
		p *= rotY(fmengerflake_rotation_xi) * rotX(fmengerflake_rotation_yi);
		w /= power;

		if (fmengerflake_mode == 1) p.xz += vec2(w);
		else if (fmengerflake_mode == 2) p.xyz -= w / fract(w);
		else if (fmengerflake_mode == 3) p.xyz += abs(w);
		else if (fmengerflake_mode == 4) p.xyz += fract(abs(w * fmengerflake_fold4_multiplier));
		else if (fmengerflake_mode == 5) p.zxy += fract(w) * (abs(w) * 1.5);
		else if (fmengerflake_mode == 6) p.xyz += w * abs(w) * fract(w);
		else if (fmengerflake_mode == 7) {};

		if (coloring_mode == 0) orbit_trap = min(orbit_trap, abs(dot(p, p)));
		else orbit_trap = min(orbit_trap, process_orbit_trap(p));
	}

	vec3 q = p - clamp(p, -vec3(w), vec3(w));
	float d = length(q) * sign(p.y);
	return vec2(d, orbit_trap);
}
