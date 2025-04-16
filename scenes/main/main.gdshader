shader_type canvas_item;

uniform float sharpness : hint_range(0.0, 10.0) = 1.0;

void fragment() {
	vec4 result;

	// Apply the sharpness filter to the current texture
	if (sharpness >= 0.0001) {
		vec2 pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0));
		vec4 center = texture(TEXTURE, UV);
		vec4 up = texture(TEXTURE, UV + vec2(0.0, -pixel_size.y));
		vec4 down = texture(TEXTURE, UV + vec2(0.0, pixel_size.y));
		vec4 left = texture(TEXTURE, UV + vec2(-pixel_size.x, 0.0));
		vec4 right = texture(TEXTURE, UV + vec2(pixel_size.x, 0.0));
		result = center * (1.0 + 4.0 * sharpness) - (up + down + left + right) * sharpness;
	} else {
		result = texture(TEXTURE, UV);
	}

	COLOR = result;
}