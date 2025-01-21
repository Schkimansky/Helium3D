#include "res://renderer/sdf/fractalsdf.gdshaderinc"

float soft_shadow(vec3 ro, vec3 rd, float mint, float maxt, float k) {
    float res = 1.0;
    float t = mint;
    vec3 final_z;

    for (int i = 0; i < 64 && t < maxt; i++) { // Higher step count for smoother shadows
        float h = scene_sdf(ro + rd * t, final_z).y;
        if (h < 0.001) return ambient_light; // Early exit for intersections
        res = min(res, k * h / t); // Accumulate shadow softness
        t += h * 0.5; // Dynamic step size
    }

    return clamp(res, ambient_light, 2.0); // Ensure shadows don't exceed brightness limits
}

float get_light(vec3 p, vec3 light_pos, vec3 normal) {
    vec3 to_light = normalize(light_pos - p);
    float light_intensity = 0.6;
    float light = light_intensity * clamp(dot(to_light, normal), 0.0, 1.0);

    float shadow = soft_shadow(p + normal * surface_distance, to_light, surface_distance, max_distance, 32.0);
    light *= mix(0.4, 1.0, shadow); // Adjust blend for softer light
    return max(light, 0.0);
}
