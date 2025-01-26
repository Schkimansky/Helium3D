#include "res://renderer/sdf/fractalsdf.gdshaderinc"

float calculate_ambient_occlusion(vec3 p, vec3 normal) {
	float occlusion = 0.0;
	float weight = 1.0 / float(ambient_occlusion_steps);

	for (int i = 0; i < ambient_occlusion_steps; i++) {
		float scale = float(i + 1) / float(ambient_occlusion_steps);
		vec3 sample_point = p + normal * scale * ambient_occlusion_radius;
		float d = scene_sdf(sample_point).y;
		occlusion += max(ambient_occlusion_radius - d, 0.0) * weight / ambient_occlusion_radius;
	}

	return 1.0 - clamp(occlusion, 0.0, 1.0);
}
