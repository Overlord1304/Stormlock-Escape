shader_type canvas_item;

uniform float saturation : hint_range(0.0, 3.0) = 1.0;

void fragment() {
	// Start with the ColorRect’s color
	vec4 color = COLOR;

	// Handle transparency properly
	if (color.a == 0.0) {
		discard;
	}

	// Convert to grayscale (luminance)
	float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));

	// Mix between grayscale and original color
	color.rgb = mix(vec3(gray), color.rgb, saturation);

	COLOR = color;
}
