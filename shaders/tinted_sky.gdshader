shader_type sky;

uniform sampler2D sky_texture : source_color, hint_default_white, filter_linear;
uniform vec3 color : source_color = vec3(1.0);

void sky() {
	COLOR = texture(sky_texture, SKY_COORDS).rgb * color;
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
		if (!AT_CUBEMAP_PASS) {
			COLOR /= 2.0;
		}
	#endif
}
