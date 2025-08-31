shader_type canvas_item;

uniform sampler2D noise_texture: repeat_enable, filter_nearest;
uniform float density: hint_range(0.0, 1.0, 0.01) = 0.85;
uniform vec2 speed = vec2(-0.002, -0.002);

void fragment() {
	vec2 uv = UV + speed * TIME;

	float noise = texture(noise_texture, uv).r;

	COLOR.a = noise * density;

}
