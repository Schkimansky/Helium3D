
vec3 sphere_invert(vec3 pos, vec4 sphere, vec3 diff, float diff_length_squared){
	return (diff * sphere.w * sphere.w) / diff_length_squared + sphere.xyz;
}

float fast_distance_approx(float dx, float dy) {
    float w;
    if (dy < dx) {
        w = dy * 0.25;
        return dx + w + (w * 0.5);
    } else {
        w = dx * 0.25;
        return dy + w + (w * 0.5);
    }
}

float fastdist_sq(vec3 p1, vec3 p2) {
	return dot(p1 - p2, p1 - p2);
}

vec2 klenianschottky_sdf(vec3 pos, float power){
	pos *= 10.0;
	vec4 baseSphere = fklenianschottky_base_sphere;
	vec4 s1 = fklenianschottky_s_1;
	vec4 s2 = fklenianschottky_s_2;
	vec4 s3 = fklenianschottky_s_3;
	vec4 s4 = fklenianschottky_s_4;
	vec4 s5 = fklenianschottky_s_5;
	vec4 s6 = fklenianschottky_s_6;
	float s1r2 = s1.w * s1.w;
	float s2r2 = s2.w * s2.w;
	float s3r2 = s3.w * s3.w;
	float s4r2 = s4.w * s4.w;
	float s5r2 = s5.w * s5.w;
	float s6r2 = s6.w * s6.w;
	float dr = 1.0;
	float scalingFactor = 0.04;
	float orbit_trap = 0.0;

	for(int i = 0; i < iterations; i++){
		if (fastdist_sq(pos, s1.xyz) < s1r2){
			vec3 diff = (pos - s1.xyz);
			float diff_length_squared = dot(diff, diff);
			dr *= s1r2 / diff_length_squared;
			pos = sphere_invert(pos, s1, diff, diff_length_squared);
		} else if (fastdist_sq(pos, s2.xyz) < s2r2){
			vec3 diff = (pos - s2.xyz);
			float diff_length_squared = dot(diff, diff);
			dr *= s2r2 / diff_length_squared;
			pos = sphere_invert(pos, s2, diff, diff_length_squared);
		} else if (fastdist_sq(pos, s3.xyz) < s3r2){
			vec3 diff = (pos - s3.xyz);
			float diff_length_squared = dot(diff, diff);
			dr *= s3r2 / diff_length_squared;
			pos = sphere_invert(pos, s3, diff, diff_length_squared);
		} else if (fastdist_sq(pos, s4.xyz) < s4r2){
			vec3 diff = (pos - s4.xyz);
			float diff_length_squared = dot(diff, diff);
			dr *= s4r2 / diff_length_squared;
			pos = sphere_invert(pos, s4, diff, diff_length_squared);
		} else if (fastdist_sq(pos, s5.xyz) < s5r2){
			vec3 diff = (pos - s5.xyz);
			float diff_length_squared = dot(diff, diff);
			dr *= s5r2 / diff_length_squared;
			pos = sphere_invert(pos, s5, diff, diff_length_squared);
		} else if (fastdist_sq(pos, s6.xyz) < s6r2){
			vec3 diff = (pos - s6.xyz);
			float diff_length_squared = dot(diff, diff);
			dr *= s6r2 / diff_length_squared;
			pos = sphere_invert(pos, s6, diff, diff_length_squared);
		} else break;
	}

	float d = (distance(pos, baseSphere.xyz) - baseSphere.w) / abs(dr) * scalingFactor;
	return vec2(d, orbit_trap);
}
