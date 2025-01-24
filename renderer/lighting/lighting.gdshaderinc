#include "res://renderer/sdf/fractalsdf.gdshaderinc"

// Soft shadow calculation
float soft_shadow(vec3 p, vec3 light_pos, float k) {
    vec3 rd = normalize(light_pos - p);
    float res = 1.0;
    float ph = 1e20; // Previous hit distance
    float t = surface_distance + self_shadow_bias;
    float min_step_size = 0.1; // Minimum step size to avoid tiny steps

    for (int i = 0; i < shadow_steps; i++) {
        vec3 final_z;
        float h = scene_sdf(p + rd * t, final_z).y;

        // Early exit for hard shadows
        if (h < surface_distance) {
            return 0.0;
        }

        // Soft shadow calculation
        float y = h * h / (2.0 * ph);
        float d = sqrt(h * h - y * y);
        res = min(res, k * d / max(0.0, t - y));
        ph = h;

        // Sphere tracing: take larger steps
        t += max(h, min_step_size);

        // Early exit if the ray goes too far
        if (t >= max_distance) {
            break;
        }
    }

    return clamp(res, 0.0, 1.0);
}

// Updated get_light function with soft shadows
float get_light(vec3 p, vec3 light_pos, vec3 normal) {
    vec3 to_light = normalize(light_pos - p);
    float light_intensity = 0.6;
    float light = light_intensity * clamp(dot(to_light, normal), 0.0, 1.0);

    // Add soft shadow
    float shadow = soft_shadow(p, light_pos, shadow_softness); // Adjust 'k' for softer/harder shadows
    light *= max(shadow, 0.- - shadow_darkness);

    return max(light, 0.0);
}