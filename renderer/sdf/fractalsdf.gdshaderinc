#include "res://renderer/mathapprox.gdshaderinc"

vec2 fractal_sdf(vec3 p, out vec3 final_z) {
	vec3 scaled_p = p / size;
	vec3 z = is_z_dynamic ? scaled_p : z_constant;
	vec3 c = is_c_dynamic ? scaled_p : c_constant;

	//c.z = sin(TIME) * 2.4;

	float r = length(z);
	float dz = 1.0;
	float powercache1 = (power - 1.0) * 0.5;

	for (int i = 0; i < iterations; i++) {
		if (zabs) z = abs(z);

		dz = power * pow(r, powercache1) * dz + 1.0;
		float th = power * fast_acos(z.z / r);
		float ph = power * atan(z.y, z.x);

		z = pow(r, power) * vec3(sin(th) * cos(ph), sin(ph) * sin(th), cos(th));
		z += c;

        r = length(z);

		if (r >= escape_radius) {
			final_z= z;
			return vec2(log(r) * sqrt(r) / dz, float(i));
        };
    }

	final_z = z;
    return vec2(0.8 * log(r) * sqrt(r) / dz, float(iterations));
}

vec2 scene_sdf(vec3 p, out vec3 z) {
	vec2 data = fractal_sdf(p, z);
	float signed_distance = data.x;
	float iterations_to_escape = data.y;

	return vec2(iterations_to_escape, signed_distance);
}
