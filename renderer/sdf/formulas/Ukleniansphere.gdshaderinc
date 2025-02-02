vec2 kleinian_sphere_sdf(vec3 p) {
    float d = sphere_sdf3d(p, vec3(0.0), 1.0);
    float scale = 1.0;
	float previous_offset = 9.0;
    for (int i = 0; i < iterations; i++) {
        // Six directions: ±x, ±y, ±z
        // Each new sphere has half the radius and is placed at twice the previous radius distance
        scale *= 2.0;
        p += 1.0 / scale;

        // Calculate distance to new spheres in each direction
        d = min(d, sphere_sdf3d(p - (vec3(1.0, 0.0, 0.0)), vec3(0.0), 0.5) / scale);
        //d = min(d, sphere_sdf3d(p + vec3(1.0, 0.0, 0.0), vec3(0.0), 0.5) / scale);
        //d = min(d, sphere_sdf3d(p - vec3(0.0, 1.0, 0.0), vec3(0.0), 0.5) / scale);
        //d = min(d, sphere_sdf3d(p + vec3(0.0, 1.0, 0.0), vec3(0.0), 0.5) / scale);
        //d = min(d, sphere_sdf3d(p - vec3(0.0, 0.0, 1.0), vec3(0.0), 0.5) / scale);
        //d = min(d, sphere_sdf3d(p + vec3(0.0, 0.0, 1.0), vec3(0.0), 0.5) / scale);
    }
    return vec2(d, 0.0);
}