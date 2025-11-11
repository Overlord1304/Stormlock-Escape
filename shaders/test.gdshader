shader_type canvas_item;

uniform float saturation : hint_range(0.0, 3.0) = 1.0;

void fragment() {
	vec3 color = texture(TEXTURE, UV).rgb;
	
	// Convert to grayscale (luminance)
	float gray = dot(color, vec3(0.299, 0.587, 0.114));
	
	// Mix between grayscale and original color based on saturation
	color = mix(vec3(gray), color, saturation);
	
	COLOR = vec4(color, texture(TEXTURE, UV).a);
}