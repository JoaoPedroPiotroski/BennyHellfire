shader_type canvas_item;

uniform float buff_enabled = 0.0;

void fragment() {
	vec3 color = texture(TEXTURE, UV).rgb;
	vec3 i_color = vec3(1.0);
	COLOR.rgb = mix(color, i_color, buff_enabled - 0.1);
}
