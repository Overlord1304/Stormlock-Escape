shader_type canvas_item;

uniform float saturation : hint_range(0.0, 3.0) = 1.0;

void fragment() {
	
	vec4 color = COLOR;


	if (color.a == 0.0) {
		discard;
	}


	float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));

	
	color.rgb = mix(vec3(gray), color.rgb, saturation);

	COLOR = color;
}
