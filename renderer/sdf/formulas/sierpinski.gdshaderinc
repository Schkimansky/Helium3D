vec2 sierpinski_sdf(vec3 z, float power) {
	float Scale = power;
	float Offset = 1.0;
	float alpha = fsierpinski_rotation_x;
	float beta = fsierpinski_rotation_y;
	float orbit_trap = 1000000.0;

	float r;
	int n = 0;
	while (n < int(iterations)) {
		if (z.x + z.y < 0.0) z.xy = -z.yx; // fold 1
		if (z.x + z.z < 0.0) z.xz = -z.zx; // fold 2
		if (z.y + z.z < 0.0) z.zy = -z.yz; // fold 3
		z = z * Scale - Offset * (Scale - 1.0);
		z.xz = vec2(cos(alpha) * z.x - sin(alpha) * z.z, sin(alpha) * z.x + cos(alpha) * z.z); // Y-axis rotation
		z.yz = vec2(cos(beta) * z.y - sin(beta) * z.z, sin(beta) * z.y + cos(beta) * z.z);     // X-axis rotation

		orbit_trap = min(orbit_trap, dot(z, z));

		n++;
	}

	return vec2(length(z) * pow(Scale, -float(n)), orbit_trap);
}

vec2 sierpinski4d_sdf(vec3 z3d, float power) {
	vec4 z = vec4(z3d, 0.0);
    float Scale = power;
    float Offset = 1.0;
    float alpha = fsierpinski4d_rotation_x; // Rotation around Y-axis in 4D
    float beta = fsierpinski4d_rotation_y;  // Rotation around X-axis in 4D
    float gamma = fsierpinski4d_rotation_z;//ftetraglad_rotation_z; // Rotation around Z-axis in 4D
	float orbit_trap = 1000000.0;

    float r;
    int n = 0;
    while (n < int(iterations)) {
        // Folding in 4D
        if (z.x + z.y < 0.0) z.xy = -z.yx; // fold 1
        if (z.x + z.z < 0.0) z.xz = -z.zx; // fold 2
        if (z.y + z.z < 0.0) z.zy = -z.yz; // fold 3
        if (z.x + z.w < 0.0) z.xw = -z.wx; // fold 4 (new for 4D)
        if (z.y + z.w < 0.0) z.yw = -z.wy; // fold 5 (new for 4D)
        if (z.z + z.w < 0.0) z.zw = -z.wz; // fold 6 (new for 4D)

        z = z * Scale - Offset * (Scale - 1.0);

        // 4D Rotations
        // Y-axis rotation (affects x and z)
        z.xz = vec2(cos(alpha) * z.x - sin(alpha) * z.z, sin(alpha) * z.x + cos(alpha) * z.z);
        // X-axis rotation (affects y and z)
        z.yz = vec2(cos(beta) * z.y - sin(beta) * z.z, sin(beta) * z.y + cos(beta) * z.z);
        // Z-axis rotation (affects x and y)
        z.xy = vec2(cos(gamma) * z.x - sin(gamma) * z.y, sin(gamma) * z.x + cos(gamma) * z.y);
        // W-axis rotation (affects x and w, y and w, z and w)
        z.xw = vec2(cos(gamma) * z.x - sin(gamma) * z.w, sin(gamma) * z.x + cos(gamma) * z.w);
        z.yw = vec2(cos(gamma) * z.y - sin(gamma) * z.w, sin(gamma) * z.y + cos(gamma) * z.w);
        z.zw = vec2(cos(gamma) * z.z - sin(gamma) * z.w, sin(gamma) * z.z + cos(gamma) * z.w);

		orbit_trap = min(orbit_trap, dot(z, z));

        n++;
    }

    // Calculate distance in 4D
    return vec2(length(z) * pow(Scale, -float(n)), orbit_trap);
}
