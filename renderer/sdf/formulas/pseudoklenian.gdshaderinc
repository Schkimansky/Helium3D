
vec3 invertSphere(vec3 point, vec4 sph) {
	vec3 diff = point - sph.xyz;
	float length_squared = length(diff) * length(diff);
	float scale = sph.w * sph.w / length_squared;
	return diff * scale + sph.xyz;
}

vec2 pseudoklenian_sdf(vec3 pos, float power) {
	if (fpseudoklenian_invert) {
		power += 0.772;
		pos = invertSphere(pos, fpseudoklenian_inversion_sphere);
	}

	vec3 p = pos;
	vec3 q = pos;
	float fractal_scale = 1.0;
	float orbit_trap = 100000.0;
	float alpha = fpseudoklenian_rotation_x;
	float beta = fpseudoklenian_rotation_y;
	float symmetry = fpseudoklenian_symmetry;

	for (int i = 0; i < iterations; ++i) {
		if (fpseudoklenian_fold_mode == 0) q = 2.0 * clamp(q, fpseudoklenian_min.xyz, fpseudoklenian_max.xyz) - q;
		else if (fpseudoklenian_fold_mode == 1) q = 2.0 * fract(0.5 * q + 0.5) - 1.0;
		else if (fpseudoklenian_fold_mode == 2) {
			float angle = atan(q.y, q.x);
			angle = mod(angle, 3.14159265 / symmetry) - (3.14159265 / symmetry);
			q.xy = vec2(cos(angle), sin(angle)) * length(q.xy);
			q = 2.0 * clamp(q, fpseudoklenian_min.xyz, fpseudoklenian_max.xyz) - q;
		} else if (fpseudoklenian_fold_mode == 3) {
			q = sign(q) * min(abs(q), 3.0);
			q = 2.0 * clamp(q, fpseudoklenian_min.xyz, fpseudoklenian_max.xyz) - q;
		}

		q.xz = vec2(cos(alpha) * q.x - sin(alpha) * q.z, sin(alpha) * q.x + cos(alpha) * q.z); // Y-axis rotation
		q.yz = vec2(cos(beta) * q.y - sin(beta) * q.z, sin(beta) * q.y + cos(beta) * q.z);     // X-axis rotation

		if (fpseudoklenian_scaling_mode == 0) {
			float rp2 = dot(q, q) * (power - 0.772);
			float k1 = max(fpseudoklenian_min.w / rp2, 1.0);
			q *= k1;
			fractal_scale *= k1;
		} else if (fpseudoklenian_scaling_mode == 1) {
			float r2 = dot(q, q) * (power - 0.772);
			float k1 = max(fpseudoklenian_min.w / r2, 1.0);
			if (r2 < fpseudoklenian_min.w) q *= (fpseudoklenian_min.w / r2);
			else if (r2 > fpseudoklenian_max.w) q *= (fpseudoklenian_max.w / r2);
			fractal_scale *= k1;
		}
		if (coloring_mode == 0) orbit_trap = min(orbit_trap, dot(q, q));
		else orbit_trap = min(orbit_trap, process_orbit_trap(q));
	}

	float lxy = length(q.xy);
	float d = 0.5 * max(fpseudoklenian_max.w - lxy, lxy * q.z / length(q)) / fractal_scale;
	return vec2(d, orbit_trap);
}
