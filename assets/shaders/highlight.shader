shader_type canvas_item;

uniform float highlight;
uniform vec4 modulate : hint_color;

void fragment() {
	COLOR = texture(TEXTURE, UV) * (modulate + vec4(vec3(highlight), 0.0));
}