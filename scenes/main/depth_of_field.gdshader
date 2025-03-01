shader_type spatial;

uniform sampler2D screen_texture: hint_screen_texture;
uniform vec2 pixel_size;

int concatenate_ints(int a, int b) { return a * 100 + b; }
ivec2 split_ints(int combined) { return ivec2(combined / 100, combined % 100); }
vec3 decode_color(vec3 encoded_color) {
	ivec2 splitted_ints = split_ints(int(round(encoded_color.x)));
	float r_channel = float(splitted_ints.x) / 100.0;
	float g_channel = float(splitted_ints.y) / 100.0;
	float b_channel = encoded_color.y - 0.004;
	return vec3(r_channel, g_channel, b_channel);
}

vec3 blur(vec2 uv) {
	vec3 sum = vec3(0.0);
	float count = 0.0;
	for (int i = -1; i <= 1; i++) {
		for (int j = -1; j <= 1; j++) {
			vec2 offset = vec2(float(i), float(j)) * pixel_size;
			if (offset.x < 0.0 || offset.y < 0.0) continue;
			vec3 color = decode_color(texture(screen_texture, uv + offset).xyz);
			if (length(color) <= 0.00001) continue;

			sum += color;
			count += 1.0;
		}
	}
	return sum / count;
}

void fragment() {
	vec4 col = texture(screen_texture, SCREEN_UV);
	vec3 color = decode_color(col.xyz);
	float dfo = col.z * 1000.0;
	//color = blur(SCREEN_UV);
	color += decode_color(texture(screen_texture, SCREEN_UV + vec2(0.0, 0.1)).xyz);
	color /= 2.0;

	EMISSION = color;
}
