shader_type spatial;
render_mode unshaded;

group_uniforms shadows;
uniform float self_shadow_bias = 0.01;
uniform float shadow_darkness = 0.7;
uniform int shadow_steps = 4;
uniform float shadow_softness = 64.0;

group_uniforms rendering;
uniform vec3 light1_position = vec3(1.3, 1.6, -1.0);
uniform vec3 light2_position = vec3(1.3, 1.6, -1.0);
uniform vec3 light1_color: source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 light2_color: source_color = vec3(1.0, 1.0, 1.0);

uniform int iterations = 8;
uniform int max_steps = 120;
uniform float ambient_light = 0.5;
uniform float max_distance = 10.0;
uniform float surface_distance = 0.000003;
uniform float raystep_multiplier = 1.0;
uniform sampler2D palette;

group_uniforms fractal;
uniform sampler2D bg_color;
uniform float size = 1.0;
uniform int formula = 1;
uniform float power = 2.0;
uniform float escape_radius = 2.0;

uniform vec3 fjuliabulb_c = vec3(0.35, 0.35, 0.35);

group_uniforms post_processing;
uniform int ambient_occlusion_steps = 6;
uniform float ambient_occlusion_radius = 0.5;
uniform float vignette_strength = 0.7;
uniform float vignette_radius = 0.8;

group_uniforms taa;
uniform int jitter_steps = 1;
uniform float jitter_offset_base = 0.0001;
uniform vec2 frame_offset = vec2(0.0);

#include "mathapprox.gdshaderinc"
#include "sdf/fractalsdf.gdshaderinc"
#include "lighting/ambient_occlusion.gdshaderinc"

float smooth_iter(float n, vec3 z) {
    float log_zn = log(length(z));
    return n + 1.0 - log(log_zn) / log(2.0);
}

vec2 ray_marcher(vec3 ro, vec3 rd) {
    float dfo = 0.0;
    float iterations_to_escape;
    vec3 final_z;

    for (int i = 0; i < int(max_steps); i++) {
        vec2 data = scene_sdf(ro + rd * dfo, final_z);
        float point_distance = data.y;
        dfo += point_distance * raystep_multiplier;

        if (point_distance < surface_distance || dfo > max_distance) {
            iterations_to_escape = data.x;
            break;
        };
    }

    //float smooth_i = smooth_iter(float(iterations_to_escape), final_z);
    return vec2(iterations_to_escape, dfo);
}

#include "lighting/lighting.gdshaderinc"

vec3 calculate_normal(vec3 p) {
	float h = 0.000001;
	vec3 final_z;
	return normalize(vec3(
		scene_sdf(p + vec3(h, 0.0, 0.0), final_z).y - scene_sdf(p - vec3(h, 0.0, 0.0), final_z).y,
		scene_sdf(p + vec3(0.0, h, 0.0), final_z).y - scene_sdf(p - vec3(0.0, h, 0.0), final_z).y,
		scene_sdf(p + vec3(0.0, 0.0, h), final_z).y - scene_sdf(p - vec3(0.0, 0.0, h), final_z).y
	));
}

vec3 calculate_albedo(vec3 ray_origin, vec3 ray_dir, vec2 screen_uv) {
	vec2 data = ray_marcher(ray_origin, ray_dir);
	float iterations_to_escape = data.x;
	float dfo = data.y;
	vec3 palette_color = texture(palette, vec2(iterations_to_escape / float(iterations), 0.0)).xyz * 3.0;

	if (dfo >= max_distance) {
		return texture(bg_color, vec2(screen_uv.y, 0.0)).xyz;
	} else {
		vec3 p = ray_origin + ray_dir * dfo;
		vec3 normal = calculate_normal(p);
		float ao = calculate_ambient_occlusion(p, normal);
		float light1 = get_light(p, light1_position, normal);
		float light2 = get_light(p, light2_position, normal);
		float vignette = smoothstep(vignette_radius, vignette_radius - vignette_strength, length(screen_uv - vec2(0.5)));
		return palette_color * ao * ((light1 * light1_color) + (light2 * light2_color)) * ambient_light * vignette;
	}
}

vec2 random_jitter(vec2 uv, float seed) {
	return vec2(
		fract(sin(dot(uv.xy, vec2(12.9898, 78.233)) + seed) * 43758.5453),
		fract(cos(dot(uv.xy, vec2(26.7898, 45.345)) + seed) * 43758.5453)
	) * 2.0 - 1.0;
}

varying vec3 vertex_ls;
void vertex() { vertex_ls = VERTEX; }

vec3 accumulate_taa(vec3 ray_origin, vec3 ray_dir, vec2 screen_uv) {
	vec3 accumulated_albedo = vec3(0.0);

	for (int i = 0; i < jitter_steps; i++) {
		vec2 jitter_offset = jitter_offset_base * float(i) + frame_offset;
		vec3 jittered_ray_origin = ray_origin + vec3(jitter_offset, 0.0);
		accumulated_albedo += calculate_albedo(jittered_ray_origin, ray_dir, screen_uv);
	}

	return accumulated_albedo / float(jitter_steps);
}

void fragment() {
	vec3 ray_origin = (inverse(MODEL_MATRIX) * vec4(CAMERA_POSITION_WORLD, 1)).xyz;
	vec3 ray_dir = normalize(vertex_ls - ray_origin);

	vec3 final_albedo = accumulate_taa(ray_origin, ray_dir, SCREEN_UV);
	ALBEDO = final_albedo;
}