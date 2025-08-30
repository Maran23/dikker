shader_type canvas_item;
render_mode unshaded, blend_mix;

const float alpha_threshold = 0.1;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform int outline_size : hint_range(1, 5) = 2;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    float a = tex.a;

    // Only draw the outline if the current pixel is transparent
    if (a <= alpha_threshold) {
        vec2 px = TEXTURE_PIXEL_SIZE;
        float maxa = 0.0;

        // Check surrounding pixels within the outline range
        for (int x = -outline_size; x <= outline_size; x++) {
            for (int y = -outline_size; y <= outline_size; y++) {
                if (x == 0 && y == 0) continue;
                vec2 offs = vec2(float(x), float(y)) * px;
                maxa = max(maxa, texture(TEXTURE, UV + offs).a);
            }
        }

        // If any neighbor pixel is opaque, draw the outline color
        if (maxa > alpha_threshold) {
            COLOR = outline_color;
        }
    }

}
