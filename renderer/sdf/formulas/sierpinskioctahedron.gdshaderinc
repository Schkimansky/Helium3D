
vec2 sierpinskioctahedron_sdf(vec3 z, float scale) {
	vec3 offset = fsierpinskioctahedron_offset;
	float orbit_trap = 100000.0;
	float r;
	int n = 0;

	while (n < iterations) {
		z.xz = vec2(cos(fsierpinskioctahedron_rotation.x) * z.x - sin(fsierpinskioctahedron_rotation.x) * z.z, sin(fsierpinskioctahedron_rotation.x) * z.x + cos(fsierpinskioctahedron_rotation.x) * z.z);
		z.yz = vec2(cos(fsierpinskioctahedron_rotation.y) * z.y - sin(fsierpinskioctahedron_rotation.y) * z.z, sin(fsierpinskioctahedron_rotation.y) * z.y + cos(fsierpinskioctahedron_rotation.y) * z.z);

		z = abs(z);
		if (z.x + z.y < 0.0) z.xy = -z.yx;
		if (z.x + z.z < 0.0) z.xz = -z.zx;
		if (z.x - z.y < 0.0) z.xy = z.yx;
		if (z.x - z.z < 0.0) z.xz = z.zx;

		z = z * scale - offset * (scale - 1.0);

		z.xz = vec2(cos(fsierpinskioctahedron_rotation.z) * z.x - sin(fsierpinskioctahedron_rotation.z) * z.z, sin(fsierpinskioctahedron_rotation.z) * z.x + cos(fsierpinskioctahedron_rotation.z) * z.z);
		z.yz = vec2(cos(fsierpinskioctahedron_rotation.w) * z.y - sin(fsierpinskioctahedron_rotation.w) * z.z, sin(fsierpinskioctahedron_rotation.w) * z.y + cos(fsierpinskioctahedron_rotation.w) * z.z);

		r = dot(z, z);
		orbit_trap = min(orbit_trap, abs(r));
		n++;
	}

	return vec2(length(z) * pow(scale, float(-n)), orbit_trap);
}

//vec2 sierpinskioctahedron_sdf(vec3 z, float scale) {
	//vec3 offset = fsierpinskioctahedron_offset;
    //float r;
    //int n = 0;
//
    //while(n < iterations) {
        //if(z.x + z.y < 0.0) z.xy = -z.yx;
        //if(z.x + z.z < 0.0) z.xz = -z.zx;
        //if(z.x - z.y < 0.0) z.xy = z.yx;
        //if(z.x - z.z < 0.0) z.xz = z.zx;
//
        //z = z * scale - offset * (scale - 1.0);
//
        //r = dot(z, z);
        //n++;
    //}
//
    //return vec2(length(z) * pow(scale, -float(n)), 0.0);
//}
