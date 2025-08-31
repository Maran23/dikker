shader_type canvas_item;

uniform vec4 shine_color: source_color = vec4(0.0, 0.0, 0.0, 0.75);
uniform float shine_angle: hint_range(0, 180, 0.1) = 45.0;
uniform float shine_size: hint_range(0.01, 1.0, 0.01) = 0.25;
uniform float speed: hint_range(-5, 5, 0.1) = 2.0;

void fragment() {
	if (COLOR.a > 0.0) {
		// Calculate shine progress based on time.
		float shine_progress = tan(TIME * speed);
	
		// Calculate the direction of the shine based on angle.
		float angle_rad = radians(shine_angle);
		vec2 shine_direction = vec2(cos(angle_rad), sin(angle_rad));

		// Calculate the shine value based on UV and the direction.
		float shine_value = dot(UV, shine_direction);

		// Determine shine visibility.
		float shine_value_progress = step(shine_value, shine_progress);
		float shine_alpha = step(shine_value, shine_progress + shine_size) - shine_value_progress;
		
		// Mix the original color with the shine color based on calculated alpha
		COLOR.rgb = mix(COLOR.rgb, shine_color.rgb, shine_alpha * shine_color.a);
	}
}