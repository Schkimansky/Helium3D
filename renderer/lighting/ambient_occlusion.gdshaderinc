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


float calcAO( in vec3 pos, in vec3 normal ) {
	float occ = 0.0;
    float sca = 1.0;
    for( int i=0; i<5; i++ )
    {
        float h = 0.01 + 0.12 * float(i) / 4.0;
        float d = scene_sdf(pos + h * normal).y;
        occ += (h - d) * sca;
        sca *= 0.95;
        if(occ > 0.35) break;
    }
    return clamp( 1.0 - 3.0 * occ, 0.0, 1.0 ) * (0.5 + 0.5 * normal.y);
}
