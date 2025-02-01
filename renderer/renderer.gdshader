shader_type spatial;
render_mode unshaded;

group_uniforms shadows;
uniform float self_shadow_bias = 0.01;
uniform float shadow_darkness = 0.7;
uniform int shadow_steps = 4;
uniform float shadow_softness = 64.0;
uniform float e = 0.0;

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
uniform int formulas[10];
uniform float formula_weights[10];
uniform float power = 2.0;
uniform float escape_radius = 2.0;

// Juliabulb
group_uniforms juliabulb;
uniform vec3 fjuliabulb_c = vec3(0.35, 0.35, 0.35);
// Mandelbox
group_uniforms mandelbox;
uniform vec3 fmandelbox_sphere_fold = vec3(0.0, 1.0, 1.0);
uniform vec3 fmandelbox_box_size = vec3(1.0, 1.0, 1.0);
uniform float fmandelbox_sphere_reflection = 0.0;
uniform float fmandelbox_spread = 1.0;
uniform float fmandelbox_stoneness = 0.0;
uniform float fmandelbox_divisions = 0.0;
uniform vec3 fmandelbox_sphere_reflection_position = vec3(0.0, 0.0, 0.0);
// Hedgebulb
group_uniforms hedgebulb;
uniform float fhedgebulb_cosine_offset = 0.0;
uniform float fhedgebulb_cosine_multiplier = 1.0;
uniform float fhedgebulb_sine_multiplier = 0.0;
// Boxbloat
group_uniforms boxbloat;
uniform float fboxbloat_cosine_multiplier = 1.0;
uniform float fboxbloat_abs_multiplier = 1.0;
// Trenchbloat
group_uniforms trenchbloat;
uniform float ftrenchbloat_cosine_multiplier1 = 1.0;
uniform float ftrenchbloat_cosine_multiplier2in = 1.0;
uniform float ftrenchbloat_cosine_multiplier2out = 1.0;
//// Basebox
group_uniforms basebox;
uniform float fbasebox_tan_multiplier = 1.0;
uniform float fbasebox_abs_multiplier = 1.0;
uniform float fbasebox_cosine_multiplier1 = 1.0;
uniform float fbasebox_cosine_multiplier2 = 1.0;
// Starbloat
group_uniforms starbloat;
uniform vec3 fstarbulb_adder = vec3(1.0, 1.0, 1.0);
uniform vec3 fstarbulb_multiplier = vec3(1.0, 1.0, 1.0);
// Wingtail
group_uniforms wingtail;
uniform vec3 fwingtail_adder = vec3(0.0, 0.0, 1.0);
uniform vec3 fwingtail_multiplier = vec3(1.5, 1.0, 1.0);
// Tribulb
group_uniforms tribulb;
uniform vec3 ftribulb_multiplier1 = vec3(1.0, 1.0, 1.0);
uniform vec3 ftribulb_multiplier2 = vec3(1.0, 1.0, 1.0);
// Juliaswirl
group_uniforms juliaswirl;
uniform vec3 fjuliaswirl_c = vec3(1.0, 1.0, 1.0);
uniform vec3 fjuliaswirl_csqrt_multiplier = vec3(1.0, 1.0, 1.0);
// Trijulia
group_uniforms trijulia;
uniform vec3 ftrijulia_c = vec3(1.0, 1.0, 1.0);
uniform vec3 ftrijulia_sine_multiplier1 = vec3(1.0, 1.0, 1.0);
uniform vec3 ftrijulia_sine_multiplier2 = vec3(1.0, 1.0, 1.0);
uniform vec3 ftrijulia_cosine_multiplier = vec3(1.0, 1.0, 1.0);
// Tangentjulia
group_uniforms tangentjulia;
uniform vec3 ftangentjulia_c = vec3(1.0, 1.0, 1.0);
uniform vec3 ftangentjulia_sine_multiplier1 = vec3(1.0, 1.0, 1.0);
uniform vec3 ftangentjulia_sine_multiplier2 = vec3(1.0, 1.0, 1.0);
uniform vec3 ftangentjulia_cosine_multiplier = vec3(1.0, 1.0, 1.0);
// Juliaisland
group_uniforms juliaisland;
uniform vec3 fjuliaisland_c = vec3(1.0, 1.0, 1.0);
uniform vec3 fjuliaisland_abs_multiplier = vec3(1.0, 1.0, 1.0);
uniform vec3 fjuliaisland_cosine_multiplier = vec3(1.0, 1.0, 1.0);
// Juliabloat
group_uniforms juliabloat;
uniform vec3 fjuliabloat_c = vec3(1.0, 1.0, 1.0);
uniform vec3 fjuliabloat_abs_multiplier = vec3(1.0, 1.0, 1.0);
uniform vec3 fjuliabloat_cosine_multiplier1 = vec3(1.0, 1.0, 1.0);
uniform vec3 fjuliabloat_cosine_multiplier2 = vec3(1.0, 1.0, 1.0);
uniform vec3 fjuliabloat_sine_multiplier1 = vec3(1.0, 1.0, 1.0);
uniform vec3 fjuliabloat_sine_multiplier2 = vec3(1.0, 1.0, 1.0);

group_uniforms post_processing;
uniform int ambient_occlusion_steps = 6;
uniform float ambient_occlusion_radius = 0.5;
uniform float ambient_occlusion_darkness = 0.7;
uniform float vignette_strength = 0.7;
uniform float vignette_radius = 0.8;
uniform float glow_intensity: hint_range(0.0, 5.0) = 1.0;
uniform vec3 glow_color: source_color = vec3(1.0, 0.5, 0.2);
uniform float glow_threshold: hint_range(0.0, 100.0) = 30.0;
uniform float glow_falloff: hint_range(1.0, 10.0) = 2.0;
uniform bool super_glow = false;
uniform bool glow = false;

group_uniforms pbr;
uniform float metallicness = 0.5;
uniform float metallic_darkness = 0.3;

#include "math.gdshaderinc"
#include "sdf/fractalsdf.gdshaderinc"
#include "lighting/ambient_occlusion.gdshaderinc"

vec2 ray_marcher(vec3 ro, vec3 rd, inout int total_marches) {
	float dfo = 0.0;
	float orbit_trap_distance;

	for (int i = 0; i < int(max_steps); i++) {
		vec2 data = scene_sdf(ro + rd * dfo);
		float point_distance = data.y;
		dfo += point_distance * raystep_multiplier;
		total_marches += 1;

		if (point_distance < surface_distance || dfo > max_distance) {
			orbit_trap_distance = data.x;
			break;
		};
	}

	if (super_glow && dfo < max_distance) { total_marches = max_steps; }

	return vec2(dfo > max_distance ? 0.0 : orbit_trap_distance, dfo);
}

#include "lighting/lighting.gdshaderinc"

vec3 calculate_normal(vec3 p) {
	float h = 0.000001;
	return normalize(vec3(
		scene_sdf(p + vec3(h, 0.0, 0.0)).y - scene_sdf(p - vec3(h, 0.0, 0.0)).y,
		scene_sdf(p + vec3(0.0, h, 0.0)).y - scene_sdf(p - vec3(0.0, h, 0.0)).y,
		scene_sdf(p + vec3(0.0, 0.0, h)).y - scene_sdf(p - vec3(0.0, 0.0, h)).y
	));
}

vec3 calculate_albedo(vec3 ray_origin, vec3 ray_dir, vec2 screen_uv) {
	int total_marches;
	vec2 data = ray_marcher(ray_origin, ray_dir, total_marches);
	float iterations_to_escape = data.x;
	float dfo = data.y;
	vec3 palette_color = texture(palette, vec2((iterations_to_escape) * 3.0, 0.0)).xyz * 3.0;
	vec3 final_color;

	if (dfo >= max_distance) {
		float vignette = smoothstep(vignette_radius, vignette_radius - vignette_strength, length(screen_uv - vec2(0.5)));
		final_color = texture(bg_color, vec2(screen_uv.y, 0.0)).xyz * vignette;
	} else {
		vec3 p = ray_origin + ray_dir * dfo;
		vec3 normal = calculate_normal(p);

		float ao = max(calculate_ambient_occlusion(p, normal), ambient_occlusion_darkness);
		float light1 = get_light(p, ray_dir, ray_origin, light1_position, normal);
		float light2 = get_light(p, ray_dir, ray_origin, light2_position, normal);

		float vignette = smoothstep(vignette_radius, vignette_radius - vignette_strength, length(screen_uv - vec2(0.5)));
		final_color = palette_color * ao * ((light1 * light1_color) + (light2 * light2_color)) * ambient_light * vignette;
	}

	if (glow && float(total_marches) * raystep_multiplier > glow_threshold) {
		float final_glow_intensity = glow_intensity * smoothstep(glow_threshold, 100.0, float(total_marches) * raystep_multiplier);
		vec3 final_glow_color = glow_color * 3.0;
		final_color += final_glow_color * pow(final_glow_intensity, glow_falloff);
	}

	return final_color;
}

//vec2 random_jitter(vec2 uv, float seed) {
	//return vec2(
		//fract(sin(dot(uv.xy, vec2(12.9898, 78.233)) + seed) * 43758.5453),
		//fract(cos(dot(uv.xy, vec2(26.7898, 45.345)) + seed) * 43758.5453)
	//) * 2.0 - 1.0;
//}

varying vec3 vertex_ls;
void vertex() { vertex_ls = VERTEX; }

//vec3 accumulate_taa(vec3 ray_origin, vec3 ray_dir, vec2 screen_uv) {
	//vec3 accumulated_albedo = vec3(0.0);
//
	//for (int i = 0; i < jitter_steps; i++) {
		//vec2 jitter_offset = jitter_offset_base * float(i) + frame_offset;
		//vec3 jittered_ray_origin = ray_origin + vec3(jitter_offset, 0.0);
		//accumulated_albedo += calculate_albedo(jittered_ray_origin, ray_dir, screen_uv);
	//}
//
	//return accumulated_albedo / float(jitter_steps);
//}

void fragment() {
	vec3 ray_origin = (inverse(MODEL_MATRIX) * vec4(CAMERA_POSITION_WORLD, 1)).xyz;
	vec3 ray_dir = normalize(vertex_ls - ray_origin);

	ALBEDO = calculate_albedo(ray_origin, ray_dir, SCREEN_UV);
}
