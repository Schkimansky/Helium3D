vec2 amazingsurf_sdf(vec3 pos, float power) {
	vec2 famazingsurf_fold = vec2(famazingsurf_fold_x, famazingsurf_fold_y);
    vec4 p = vec4(pos, 1.0);
    vec4 d = vec4(famazingsurf_c, 1.0);
    float orbit_trap = 1e4;
    float precalc1 = abs(1.0 - power);
    float precalc2 = pow(abs(power), float(1 - iterations));

    mat3 rot = rotationMatrix3(normalize(famazingsurf_rotation_vector), famazingsurf_rotation_angle);

    for (int i = 0; i < iterations; i++) {
        if (famazingsurf_mode == 1) {
            p.xy = famazingsurf_fold - abs(abs(p.xy) - famazingsurf_fold);
        } else if (famazingsurf_mode == 2) {
            p.xy = abs(p.xy + famazingsurf_fold);
        } else if (famazingsurf_mode == 3) {
            p.xy = famazingsurf_fold * abs(abs(p.xy) + famazingsurf_fold);
        } else if (famazingsurf_mode == 4) {
            p.xy = abs(p.xy + famazingsurf_fold) - abs(p.xy - famazingsurf_fold) - p.xy;
        }

        p.xyz += famazingsurf_translation;
        float r2 = dot(p.xyz, p.xyz);
        p *= power / clamp(r2, famazingsurf_min_radius, 1.0);
        p.xyz = p.xyz * rot + d.xyz;

		if (coloring_mode == 0) orbit_trap = min(orbit_trap, r2);
		else orbit_trap = min(orbit_trap, process_orbit_trap4d(p));
    }

    float dist = (length(p.xyz) - precalc1) / p.w - precalc2;
    return vec2(dist, orbit_trap);
}