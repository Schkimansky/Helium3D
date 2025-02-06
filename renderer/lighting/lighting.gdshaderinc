#include "res://renderer/sdf/fractalsdf.gdshaderinc"

float soft_shadow(vec3 p, vec3 light_pos, float k) {
	vec3 rd = normalize(light_pos - p);
	float res = 1.0;
	float ph = 1e20;
	float t = surface_distance + self_shadow_bias;

	for (int i = 0; i < shadow_steps; i++) {
		float h = scene_sdf(p + rd * t).y;

		if (h < surface_distance) {
			return 0.0;
		}

		float y = h * h / (2.0 * ph);
		float d = sqrt(h * h - y * y);
		res = min(res, k * d / max(0.0, t - y));
		ph = h;

		t += max(h, min_step_size);

		if (t >= max_distance) {
			break;
		}
	}

	return clamp(res, 0.0, 1.0);
}

vec3 get_light(vec3 p, vec3 rd, vec3 ro, vec3 light_pos, vec3 light_color, vec3 normal) {
	vec3 to_light = normalize(light_pos - p);
	float light = light_intensity * clamp(dot(to_light, normal), 0.05, 1.0);

	float shadow = soft_shadow(p, light_pos, shadow_softness);
	light *= max(shadow, shadow_darkness);
	vec3 reflection = reflect(to_light, normal);
	float specular = pow(max(dot(reflection, rd), 0.0), refraction_sharpness);
	light *= max(specular * refraction_intensity, 1.0);// + (1.0 - metallicness), metallic_darkness);

	return max(light_color * light, ambient_light);
}
