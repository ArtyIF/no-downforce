shader_type spatial;
render_mode diffuse_toon, specular_disabled, blend_add;

uniform vec3 color : source_color;

uniform sampler2D lightmap_texture : source_color, hint_default_white, repeat_disable, filter_linear_mipmap_anisotropic;
uniform vec4 lightmap_rect = vec4(0.0, 0.0, 1.0, 1.0);

void vertex() {
	float x1 = lightmap_rect.x;
	float y1 = lightmap_rect.y;
	float x2 = lightmap_rect.x + lightmap_rect.z;
	float y2 = lightmap_rect.y + lightmap_rect.w;
	UV2.x = (UV2.x * (x2 - x1)) + x1;
	UV2.y = (UV2.y * (y2 - y1)) + y1;
}

void fragment() {
	ALBEDO = color * texture(lightmap_texture, UV2).rgb;
}
