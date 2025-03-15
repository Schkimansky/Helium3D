const float golden_ratio = (1.0 + sqrt(5.0)) * 0.5;

vec3 repeat(vec3 p, vec3 spacing) {
	return mod(p + 0.5 * spacing, spacing) - 0.5 * spacing;
}

float process_orbit_trap(vec3 z) {
	if (coloring_mode == 1) { return length(z); }
	if (coloring_mode == 2) { return dot(z, z); }
	if (coloring_mode == 3) { return sqrt(length(z)); }
	if (coloring_mode == 4) { return sqrt(dot(z, z)); }
	if (coloring_mode == 5) { return abs(length(z)); }
	if (coloring_mode == 6) { return abs(dot(z, z)); }
	if (coloring_mode == 7) { return log(length(z)); }
	if (coloring_mode == 8) { return log(dot(z, z)); }
	if (coloring_mode == 9) { return exp(length(z)); }
	if (coloring_mode == 10) { return exp(dot(z, z)); }
	return 0.0;
}

float process_orbit_trap4d(vec4 z) {
	if (coloring_mode == 1) { return length(z); }
	if (coloring_mode == 2) { return dot(z, z); }
	if (coloring_mode == 3) { return sqrt(length(z)); }
	if (coloring_mode == 4) { return sqrt(dot(z, z)); }
	if (coloring_mode == 5) { return abs(length(z)); }
	if (coloring_mode == 6) { return abs(dot(z, z)); }
	if (coloring_mode == 7) { return log(length(z)); }
	if (coloring_mode == 8) { return log(dot(z, z)); }
	if (coloring_mode == 9) { return exp(length(z)); }
	if (coloring_mode == 10) { return exp(dot(z, z)); }
	return 0.0;
}

vec3 rotate3d_point(vec3 p, vec3 rot) {
	if (length(rot) <= 0.00001) return p;

	p.xz = vec2(cos(rot.x) * p.x - sin(rot.x) * p.z, sin(rot.x) * p.x + cos(rot.x) * p.z);
	p.yz = vec2(cos(rot.y) * p.y - sin(rot.y) * p.z, sin(rot.y) * p.y + cos(rot.y) * p.z);
	p.xy = vec2(cos(rot.z) * p.x - sin(rot.z) * p.y, sin(rot.z) * p.x + cos(rot.z) * p.y);

	return p;
}

vec4 rotate4d_point(vec4 p, vec4 rot) {
	if (length(rot) <= 0.00001) return p;

	p.xw = vec2(cos(rot.x) * p.x - sin(rot.x) * p.w, sin(rot.x) * p.x + cos(rot.x) * p.w);
	p.yw = vec2(cos(rot.y) * p.y - sin(rot.y) * p.w, sin(rot.y) * p.y + cos(rot.y) * p.w);
	p.zw = vec2(cos(rot.z) * p.z - sin(rot.z) * p.w, sin(rot.z) * p.z + cos(rot.z) * p.w);
	p.xy = vec2(cos(rot.w) * p.x - sin(rot.w) * p.y, sin(rot.w) * p.x + cos(rot.w) * p.y);

	return p;
}

float fast_acos(float x) {
    float a = sqrt(2.0 + 2.0 * x);
    float b = sqrt(2.0 - 2.0 * x);
    float c = sqrt(2.0 - a);
    return 8.0 / 3.0 * c - b / 3.0;
}

vec3 complexPow(vec3 z, float to_power) {
	float r = length(z);
	float theta = acos(z.z / r);
	float phi = atan(z.y, z.x);
	
	float r_pow = pow(r, to_power);
	
	float theta_pow = to_power * theta;
	float phi_pow = to_power * phi;
	
	vec3 result = r_pow * vec3(
		sin(theta_pow) * cos(phi_pow),
		sin(theta_pow) * sin(phi_pow),
		cos(theta_pow)
	);
	
	return result;
}

vec3 sphereInversion(vec3 p, vec3 center, float radius) {
    vec3 delta = p - center;
    float distSq = dot(delta, delta);
    return center + (radius * radius / distSq) * delta;
}

////////////////
// Primitives //
////////////////
float sphere_sdf3d(vec3 p, vec3 sphere_position, float radius) { return length(p - sphere_position) - radius; }
float sphere_sdf4d(vec4 p, vec4 sphere_position, float radius) { return length(p - sphere_position) - radius; }
float cube_sdf3d(vec3 p, vec3 s) { vec3 q = abs(p) - s; return length(max(q, 0.0)); }
float triangle_sdf3d(vec3 point) { return (max(abs(point.x + point.y) - point.z, abs(point.x - point.y) + point.z) - 1.0) / sqrt(3.0); }
float dodecahedron_sdf3d(vec3 p, float s) { vec3 q = abs(p); return (max(max(q.x + q.y + q.z, q.x + q.y - q.z), max(q.x - q.y + q.z, -q.x + q.y + q.z)) - s) * 0.5; }
float octahedron_sdf3d(vec3 p, float s) { vec3 k = abs(p); return (k.x + k.y + k.z - s) * 0.57735027; }

//////////////////
// Complex math //
//////////////////
