
float box_sdf3d( vec3 p, vec3 b, float e ) {
	p = abs(p) - b;
	vec3 q = abs(p + e) - e;

	return min(min(
		length(max(vec3(p.x,q.y,q.z),0.0))+min(max(p.x,max(q.y,q.z)),0.0),
		length(max(vec3(q.x,p.y,q.z),0.0))+min(max(q.x,max(p.y,q.z)),0.0)),
		length(max(vec3(q.x,q.y,p.z),0.0))+min(max(q.x,max(q.y,p.z)),0.0)
	);
}

float box_sdf4d(vec4 p, vec4 b, float e) {
	p = abs(p) - b;
	vec4 q = abs(p + e) - e;

	return min(min(min(
		length(max(vec4(p.x, q.y, q.z, q.w), 0.0)) + min(max(p.x, max(q.y, max(q.z, q.w))), 0.0),
		length(max(vec4(q.x, p.y, q.z, q.w), 0.0)) + min(max(q.x, max(p.y, max(q.z, q.w))), 0.0)),
		length(max(vec4(q.x, q.y, p.z, q.w), 0.0)) + min(max(q.x, max(q.y, max(p.z, q.w))), 0.0)),
		length(max(vec4(q.x, q.y, q.z, p.w), 0.0)) + min(max(q.x, max(q.y, max(q.z, p.w))), 0.0)
	);
}

vec2 fresnelcube4d_sdf(vec3 p3d, float power) {
	vec4 p = vec4(p3d, 0.0);
	float scale = 1.0;
	float d = 1e6;
	float alpha = ffrenselcube4d_rotation_x;
	float beta = ffrenselcube4d_rotation_y;
	float gamma = ffrenselcube4d_rotation_z;
	float delta = ffrenselcube4d_rotation_w;

	for (int i = 0; i < iterations; i++) {
		p.xz = vec2(cos(alpha) * p.x - sin(alpha) * p.z, sin(alpha) * p.x + cos(alpha) * p.z);
		p.yz = vec2(cos(beta) * p.y - sin(beta) * p.z, sin(beta) * p.y + cos(beta) * p.z);
		p.xw = vec2(cos(gamma) * p.x - sin(gamma) * p.w, sin(gamma) * p.x + cos(gamma) * p.w);
		p.yw = vec2(cos(delta) * p.y - sin(delta) * p.w, sin(delta) * p.y + cos(delta) * p.w);

		float size = scale * pow(ffrenselcube4d_falloff, float(i));

		d = min(d, box_sdf4d(p, vec4(size), ffrenselcube4d_thickness * size));
	}

	return vec2(d, 0.0);
}

vec2 fresnelcube_sdf(vec3 p, float power) {
	float scale = 1.0;
	float d = 1e6;
	float alpha = ffrenselcube_rotation_x;
	float beta = ffrenselcube_rotation_y;

	for (int i = 0; i < iterations; i++) {
		p.xz = vec2(cos(alpha) * p.x - sin(alpha) * p.z, sin(alpha) * p.x + cos(alpha) * p.z);
		p.yz = vec2(cos(beta) * p.y - sin(beta) * p.z, sin(beta) * p.y + cos(beta) * p.z);

		float size = scale * pow(ffrenselcube_falloff, float(i));
		d = min(d, box_sdf3d(p, vec3(size), ffrenselcube_thickness * size));
	}

	return vec2(d, 0.0);
}

//vec2 frenselcube_multi_sdf(vec3 p3d, float power, int dimensions) {
	//vec4 p = vec4(p3d, 0.0);
	//float scale = 1.0;
	//float d = 1e6;
	//float alpha = ffrenselcube_rotation_x;
	//float beta = ffrenselcube_rotation_y;
	//float gamma = ffrenselcube_rotation_z;
	//float delta = ffrenselcube_rotation_w;
	//
	//for (int i = 0; i < iterations; i++) {
		//p.xz = vec2(cos(alpha) * p.x - sin(alpha) * p.z, sin(alpha) * p.x + cos(alpha) * p.z);
		//p.yz = vec2(cos(beta) * p.y - sin(beta) * p.z, sin(beta) * p.y + cos(beta) * p.z);
		//
		//if (dimensions == 4) {
			//p.xw = vec2(cos(gamma) * p.x - sin(gamma) * p.w, sin(gamma) * p.x + cos(gamma) * p.w);
			//p.yw = vec2(cos(delta) * p.y - sin(delta) * p.w, sin(delta) * p.y + cos(delta) * p.w);
		//}
		//
		//float size = scale * pow(ffrenselcube_falloff, float(i));
		//
		//if (dimensions == 4) d = min(d, box_sdf4d(p, vec4(size), ffrenselcube_thickness * size));
		//else if (dimensions == 3) d = min(d, box_sdf3d(p.xyz, vec3(size), ffrenselcube_thickness * size));
	//}
	//
	//return vec2(d, 0.0);
//}

//vec2 fresnelcube_sdf(vec3 p, float power) {
	//float scale = 1.0;
	//float d = 1e6;
	//float alpha = ffrenselcube_rotation_x;
	//float beta = ffrenselcube_rotation_y;
	//
	//for (int i = 0; i < iterations; i++) {
		//p.xz = vec2(cos(alpha) * p.x - sin(alpha) * p.z, sin(alpha) * p.x + cos(alpha) * p.z);
		//p.yz = vec2(cos(beta) * p.y - sin(beta) * p.z, sin(beta) * p.y + cos(beta) * p.z);
		//
		//float size = scale * pow(ffrenselcube_falloff, float(i));
		//d = min(d, box_sdf(p, vec3(size), 0.05 * size));
	//}
	//return vec2(d, 0.0);
//}
