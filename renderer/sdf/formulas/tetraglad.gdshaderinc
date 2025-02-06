
vec2 tetraglad_sdf(vec3 p, float power) {
    float scale = power + 1.0;
    float colorind = 0.0;

    // Rotation angles (can be controlled externally)
    float alpha = ftetraglad_rotation_x; // Y-axis rotation
    float beta = ftetraglad_rotation_y;  // X-axis rotation
	int n = 0;

    for (; n < iterations; n++) {
        // Apply rotations
        p.xz = vec2(cos(alpha) * p.x - sin(alpha) * p.z, sin(alpha) * p.x + cos(alpha) * p.z); // Y-axis rotation
        p.yz = vec2(cos(beta) * p.y - sin(beta) * p.z, sin(beta) * p.y + cos(beta) * p.z);     // X-axis rotation

        p = abs(p);
        if (p.x + p.y < 0.0) p.xy = -p.yx;
        if (p.x + p.z < 0.0) p.xz = -p.zx;
        if (p.y + p.z < 0.0) {
            p.zy = -p.yz;
            colorind++;
        }
        p = p * scale - vec3(1) * (scale - 1.0);
    }
    float d = length(p) * pow(scale, -float(n));
    return vec2(d, colorind / float(n));
}
