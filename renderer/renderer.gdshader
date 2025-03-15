shader_type spatial;
//render_mode unshaded;

group_uniforms shadows;
uniform float self_shadow_bias = 0.01;
uniform float shadow_darkness = 0.2;
uniform int shadow_steps = 32;
uniform float shadow_softness = 12.0;

group_uniforms rendering;
uniform float light_intensity = 0.6;
uniform vec3 light1_position = vec3(10.0, 10.0, -10.0);
uniform vec3 light2_position = vec3(-10.0, -10.0, 10.0);
uniform vec3 light1_color: source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 light2_color: source_color = vec3(1.0, 1.0, 1.0);

group_uniforms coloring;
uniform sampler2D palette;
uniform int coloring_mode = 0;
uniform int iterations = 8;
uniform int max_steps = 120;
uniform float ambient_light = 0.08;
uniform float max_distance = 30.0;
uniform float raystep_multiplier = 1.0;
uniform float surface_distance = 0.000003;
uniform bool relative_epsilon = false;

group_uniforms fractal;
uniform sampler2D bg_color;
uniform int formulas[10];
uniform float powers[10];
uniform float escape_radius = 8.0;

group_uniforms post_processing;
// Ambient Occlusion
uniform int ambient_occlusion_steps = 6;
uniform float ambient_occlusion_radius = 0.5;
uniform float ambient_occlusion_darkness = 0.7;
// Vignette
uniform float vignette_strength = 0.7;
uniform float vignette_radius = 0.8;
// Glow
uniform float glow_intensity: hint_range(0.0, 5.0) = 1.0;
uniform vec3 glow_color: source_color = vec3(1.0, 0.5, 0.2);
uniform sampler2D glow_palette;
uniform float glow_threshold: hint_range(0.0, 100.0) = 30.0;
uniform float glow_falloff: hint_range(1.0, 10.0) = 2.0;
uniform bool super_glow = false;
uniform bool glow = false;
// Fog
uniform vec3 fog_color: source_color = vec3(0.5, 0.6, 0.7);
uniform float fog_density = 0.01;
uniform float fog_falloff = 1.64;

group_uniforms pbr;
uniform float refraction_intensity = 2.611;
uniform float refraction_sharpness = 8.0;
uniform float metallicness = 0.5;
uniform float min_step_size = 0.0;

uniform vec3 fresnel_color = vec3(0.0, 0.7, 1.0);
uniform float fresnel_falloff = 5.0;
uniform float fresnel_intensity = 0.0045;

#include "math.gdshaderinc"
#include "res://formulas/mandelbulb.gdshaderinc"
#include "res://formulas/mandelbox.gdshaderinc"
#include "res://formulas/sierpinskitetrahedron.gdshaderinc"
#include "res://formulas/tetraglad.gdshaderinc"
#include "res://formulas/mengersponge.gdshaderinc"
#include "res://formulas/pseudoklenian.gdshaderinc"
#include "res://formulas/amazingsurf.gdshaderinc"
#include "res://formulas/juliabulb4d.gdshaderinc"
//#include "sdf/formulas/mengerflake.gdshaderinc"
//#include "sdf/formulas/fresnelcube.gdshaderinc"
#include "res://formulas/sierpinskidodecahedron.gdshaderinc"
#include "res://formulas/sierpinskiicosahedron.gdshaderinc"
#include "res://formulas/sierpinskioctahedron.gdshaderinc"
#include "res://formulas/bairddelta.gdshaderinc"
#include "res://formulas/klenian.gdshaderinc"
#include "res://formulas/spheretree.gdshaderinc"
#include "res://formulas/kaliredux.gdshaderinc"
#include "res://formulas/kaliliving.gdshaderinc"

vec2 single_fractal_sdf(int formula, vec3 p, float power) {
	if (formula == 16) return kaliliving_sdf(p, power);
	if (formula == 15) return kaliredux_sdf(p, power);
	if (formula == 14) return spheretree_sdf(p, power);
	if (formula == 13) return klenian_sdf(p, power);
	if (formula == 12) return juliabulb4d_sdf(p, power);
	if (formula == 11) return tetraglad_sdf(p, power);
	if (formula == 10) return pseudoklenian_sdf(p, power);
	if (formula == 9) return sierpinskidodecahedron_sdf(p, power);
	if (formula == 8) return sierpinskioctahedron_sdf(p, power);
	if (formula == 7) return mengersponge_sdf(p, power);
	if (formula == 6) return sierpinskitetrahedron_sdf(p, power);
	if (formula == 5) return sierpinskiicosahedron_sdf(p, power);
	if (formula == 4) return bairddelta_sdf(p, power);
	if (formula == 3) return amazingsurf_sdf(p, power);
	if (formula == 2) return mandelbox_sdf(p, power);
	if (formula <= 1) return mandelbulb_sdf(p, power);

	return vec2(0.0, 0.0);
}

vec2 scene_sdf(vec3 p) {
	return single_fractal_sdf(formulas[0], p, powers[0]).yx;
}

//#include "sdf/fractalsdf.gdshaderinc"
#include "lighting/ambient_occlusion.gdshaderinc"

vec3 ray_marcher(vec3 ro, vec3 rd) {
	float dfo = 0.0;
	float orbit_trap_distance;
	float total_marches = 0.0;

	for (int i = 0; i < max_steps; i++) {
		vec2 data = scene_sdf(ro + rd * dfo);
		float point_distance = data.y;
		dfo += point_distance * raystep_multiplier;
		total_marches += 1.0;

		float epsilon = relative_epsilon ? surface_distance / 3.4 * dfo : surface_distance;
		if (abs(point_distance) < epsilon || dfo > max_distance) {
			orbit_trap_distance = data.x;
			break;
		};
	}

	if (super_glow && dfo < max_distance) { total_marches = float(max_steps); }

	return vec3(dfo > max_distance ? 0.0 : orbit_trap_distance, dfo, total_marches);
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


vec3 calculate_albedo(vec3 ray_origin, vec3 ray_dir, vec2 screen_uv, out float dfo) {
	vec3 data = ray_marcher(ray_origin, ray_dir);
	float orbit_trap_distance = data.x;
	dfo = data.y;
	float total_marches = data.z;
	vec3 palette_color = texture(palette, vec2(orbit_trap_distance, 0.0)).xyz;
	vec3 final_color;
	vec3 p = ray_origin + ray_dir * dfo;
	vec3 normal = calculate_normal(p);

	if (dfo >= max_distance) {
		float vignette = smoothstep(vignette_radius, vignette_radius - vignette_strength, length(screen_uv - vec2(0.5)));
		float normalized_y = (normalize(ray_dir).y + 1.0) * 0.5;
		final_color = texture(bg_color, vec2(clamp(normalized_y, 0.0, 1.0), 0)).xyz * vignette;
	} else {
		float ao = calcAO(p, normal);
		vec3 light1 = get_light(p, ray_dir, ray_origin, light1_position, light1_color, normal);
		vec3 light2 = get_light(p, ray_dir, ray_origin, light2_position, light2_color, normal);

		final_color = mix(2.0 * 3.0 * palette_color * ao * (light1 + light2 + ambient_light), vec3(0.0), metallicness);
	}

	if (glow && float(total_marches) * raystep_multiplier > glow_threshold) {
		vec3 palette_glow_color = texture(glow_palette, vec2(orbit_trap_distance * 3.0, 0.0)).xyz;
		float glow_factor = smoothstep(glow_threshold, 100.0, float(total_marches) * raystep_multiplier);
		float final_glow_intensity = (glow_intensity - 0.2) * glow_factor;
		vec3 final_glow_color = palette_glow_color * 3.0;
		final_color += 2.0 * final_glow_color * pow(final_glow_intensity, glow_falloff);
	}

	float fog_distance = dfo < max_distance ? dfo : max_distance;
	float fog_amount = 1.0 - exp(-fog_density * fog_distance);
	final_color = mix(final_color, fog_color, pow(fog_amount, fog_falloff));

	vec2 vignette_uv = screen_uv * (1.0 - screen_uv.yx);
	float vignette = pow(vignette_uv.x * vignette_uv.y * 15.0, vignette_strength);
	final_color *= vignette;

	// Fresnel
	if (dfo < max_distance) {
		float cosTheta = clamp(dot(normal, -ray_dir), 0.0, 2.0);
		float fresnelFactor = fresnel_intensity * pow(1.0 - cosTheta, fresnel_falloff);
		final_color = mix(final_color, fresnel_color, fresnelFactor);
	}

	return final_color;
}

varying vec3 vertex_ls;
void vertex() { vertex_ls = VERTEX; }

//int concatenate_ints(int a, int b) { return a * 100 + b; }
//ivec2 split_ints(int combined) { return ivec2(combined / 100, combined % 100); }

void fragment() {
	vec3 ro = (inverse(MODEL_MATRIX) * vec4(CAMERA_POSITION_WORLD, 1.0)).xyz;
	vec3 rd = normalize(vertex_ls - ro);
	float dfo;
	
	EMISSION = calculate_albedo(ro, rd, SCREEN_UV, dfo);
}