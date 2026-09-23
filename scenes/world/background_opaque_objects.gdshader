shader_type canvas_item;

uniform int draw_mode = 0;
const float NEBULA_OPACITY = 0.68;
const float DEBRIS_OPACITY = 0.78;

varying vec4 vertex_color;

void vertex() {
	vertex_color = COLOR;
}

void fragment() {
	vec4 source = texture(TEXTURE, UV);
	float brightest = max(source.r, max(source.g, source.b));
	bool planet = source.a > 0.35 && brightest < 0.34;
	bool pale_star = source.r > 0.55 && source.g > 0.55 && source.b > 0.55;
	bool amber_star = source.r > 0.55 && source.g > 0.3 && source.b < 0.35 && source.r > source.g * 1.25;
	bool star = pale_star || amber_star;
	if (source.a <= 0.0 || (draw_mode == 1 && planet) || (draw_mode == 2 && !planet)
			|| (draw_mode == 3 && !star) || (draw_mode == 4 && star)) {
		discard;
	}
	if (draw_mode == 2) {
		COLOR.rgb = max(source.rgb * 1.2, vec3(0.07, 0.08, 0.11)) * vertex_color.rgb;
		COLOR.a = vertex_color.a;
	} else if (draw_mode == 1 || draw_mode == 5) {
		COLOR.a = vertex_color.a * (star ? 1.0 : source.a * NEBULA_OPACITY);
	} else if (draw_mode == 4) {
		COLOR.a = vertex_color.a * DEBRIS_OPACITY;
	} else {
		COLOR.a = vertex_color.a;
	}
}
