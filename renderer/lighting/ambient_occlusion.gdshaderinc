#include "res://renderer/sdf/fractalsdf.gdshaderinc"

float calculate_ambient_occlusion(vec3 p, vec3 normal) {
	float occlusion = 0.0;
	float weight = 1.0 / float(ao_steps);
	vec3 final_z;
	
	for (int i = 0; i < ao_steps; i++) {
		float scale = float(i + 1) / float(ao_steps);
		vec3 sample_point = p + normal * scale * ao_radius;
		float d = scene_sdf(sample_point, final_z).y;
		occlusion += max(ao_radius - d, 0.0) * weight / ao_radius;
	}
	
	return 1.0 - clamp(occlusion, 0.0, 1.0);
}
