shader_type canvas_item;

uniform vec3 color_shift : source_color;
uniform vec3 shadow : source_color;
uniform float mix_value;

void fragment() {
	vec3 color = texture(TEXTURE, UV).rgb;
	if ((((color.r+color.b+color.g) / 3.) - color.r) > 0.) {
		COLOR.rgb = color;
	} else {
		COLOR.rgb = mix(color * color_shift, shadow, 1.- color.r - 0.5);
	}
	
}
