shader_type spatial;
render_mode unshaded;

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
uniform int iterations = 8;
uniform int max_steps = 120;
uniform float ambient_light = 0.08;
uniform float max_distance = 30.0;
uniform float surface_distance = 0.000003;
uniform float raystep_multiplier = 1.0;
uniform sampler2D palette;

group_uniforms fractal;
uniform sampler2D bg_color;
uniform int formulas[10];
//uniform float formula_weights[10];
uniform float powers[10];
uniform float escape_radius = 8.0;

// Sierpinski Octahedron
group_uniforms sierpinski_octahedron;
uniform vec4 fsierpinskioctahedron_rotation = vec4(0.0, 0.0, 0.0, 0.0);
uniform vec3 fsierpinskioctahedron_offset = vec3(0.0, 0.0, 0.0);
// Sierpinski dodecahedron
group_uniforms sierpinski_dodecahedron;
uniform vec4 fsierpinskidodecahedron_rotation = vec4(0.0, 0.0, 0.0, 0.0);
uniform vec3 fsierpinskidodecahedron_offset = vec3(0.0, 0.0, 0.0);
// Sierpinski icosahedron
group_uniforms sierpinski_icosahedron;
uniform vec4 fsierpinskiicosahedron_rotation = vec4(0.0, 0.0, 0.0, 0.0);
uniform vec3 fsierpinskiicosahedron_offset = vec3(0.0, 0.0, 0.0);
// Frenselcube
group_uniforms fresnelcube;
uniform float ffrenselcube_rotation_x = 1.3;
uniform float ffrenselcube_rotation_y = 0.0;
uniform float ffrenselcube_thickness = 0.05;
uniform float ffrenselcube_falloff = 0.5;
// Frenselcube4D
group_uniforms fresnelcube4d;
uniform float ffrenselcube4d_rotation_x = 1.3;
uniform float ffrenselcube4d_rotation_y = 0.0;
uniform float ffrenselcube4d_rotation_z = 0.0;
uniform float ffrenselcube4d_rotation_w = 0.0;
uniform float ffrenselcube4d_thickness = 0.05;
uniform float ffrenselcube4d_falloff = 0.5;
// Mengerflake
group_uniforms mengerflake;
uniform int fmengerflake_mode = 1;
uniform float fmengerflake_rotation_x = 0.0;
uniform float fmengerflake_rotation_y = 0.0;
uniform float fmengerflake_rotation_xi = 0.52; // PI / 6.0
uniform float fmengerflake_rotation_yi = 0.26; // PI / 12.0
uniform float fmengerflake_offset = 0.5;
uniform float fmengerflake_fold4_multiplier = 1.0;
uniform float fmengerflake_fold5_multiplier = 1.0;
// Sierpinski
group_uniforms sierpinski;
uniform float fsierpinski_rotation_x = 0.0;
uniform float fsierpinski_rotation_y = 0.0;
// Sierpinski4D
group_uniforms sierpinski4d;
uniform float fsierpinski4d_rotation_x = 0.0;
uniform float fsierpinski4d_rotation_y = 0.0;
uniform float fsierpinski4d_rotation_z = 0.0;
// Mengersponge
group_uniforms mengersponge;
uniform float fmengersponge_rotation_x = 0.0;
uniform float fmengersponge_rotation_y = 0.0;
// Tetraglad
group_uniforms tetraglad;
uniform float ftetraglad_rotation_x = 0.0;
uniform float ftetraglad_rotation_y = 0.0;
// Quaternion
group_uniforms quaternion;
uniform vec4 fquaternion_c = vec4(0.5, 0.5, 0.5, 0.5);
// Pseudoklenian
group_uniforms pseudoklenian;
uniform vec4 fpseudoklenian_min = vec4(-0.8323, -0.694, -0.5045, 0.8067);
uniform vec4 fpseudoklenian_max = vec4(0.8579, 1.0883, 0.8937, 0.9411);
uniform vec4 fpseudoklenian_inversion_sphere = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool fpseudoklenian_invert = false;
uniform int fpseudoklenian_scaling_mode = 1;
uniform int fpseudoklenian_fold_mode = 1;
uniform float fpseudoklenian_rotation_x = 1.0;
uniform float fpseudoklenian_rotation_y = 1.0;
uniform float fpseudoklenian_symmetry = 6.0;
// Amazingsurf
group_uniforms amazingsurf;
uniform vec3 famazingsurf_c = vec3(-1.0);
uniform int famazingsurf_mode = 1;
uniform float famazingsurf_fold_x = 1.0;
uniform float famazingsurf_fold_y = 1.0;
uniform float famazingsurf_rotation_angle = 0.0;
uniform vec3 famazingsurf_rotation_vector = vec3(1.0);
uniform float famazingsurf_min_radius = 0.25;
uniform vec3 famazingsurf_translation = vec3(0.0);
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
//uniform float refraction_color = 0.3;

// Min shadow step size.
const float min_step_size = 0.0;

#include "math.gdshaderinc"
#include "sdf/fractalsdf.gdshaderinc"
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

		if (abs(point_distance) < surface_distance || dfo > max_distance) {
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

vec3 calculate_albedo(vec3 ray_origin, vec3 ray_dir, vec2 screen_uv) {
	vec3 data = ray_marcher(ray_origin, ray_dir);
	float iterations_to_escape = data.x;
	float dfo = data.y;
	float total_marches = data.z;
	vec3 palette_color = texture(palette, vec2((iterations_to_escape) * 3.0, 0.0)).xyz * 3.0;
	vec3 final_color;

	if (dfo >= max_distance) {
		float vignette = smoothstep(vignette_radius, vignette_radius - vignette_strength, length(screen_uv - vec2(0.5)));
		final_color = texture(bg_color, vec2(screen_uv.y, 0.0)).xyz * vignette;
	} else {
		vec3 p = ray_origin + ray_dir * dfo;
		vec3 normal = calculate_normal(p);

		float ao = max(calculate_ambient_occlusion(p, normal), ambient_occlusion_darkness);
		vec3 light1 = get_light(p, ray_dir, ray_origin, light1_position, light1_color, normal);
		vec3 light2 = get_light(p, ray_dir, ray_origin, light2_position, light2_color, normal);

		final_color = palette_color * ao * (light1 + light2);
	}

	if (glow && float(total_marches) * raystep_multiplier > glow_threshold) {
		float final_glow_intensity = (glow_intensity - 0.2) * smoothstep(glow_threshold, 100.0, float(total_marches) * raystep_multiplier);
		vec3 final_glow_color = glow_color * 3.0;
		final_color += final_glow_color * pow(final_glow_intensity, glow_falloff);
	}

	float fog_distance = dfo < max_distance ? dfo : max_distance;
	float fog_amount = 1.0 - exp(-fog_density * fog_distance);
	final_color = mix(final_color, fog_color, pow(fog_amount, fog_falloff));

	// For some reason, Doing this makes glow work. Why? I DONT KNOW.
	//final_color /= 2.0;
	//final_color = min(final_color, 1.0);
	//final_color *= 2.0;
	
	float vignette = smoothstep(vignette_radius, vignette_radius - vignette_strength, length(screen_uv - vec2(0.5)));
	final_color *= vignette;
	
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
