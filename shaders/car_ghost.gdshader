shader_type spatial;
render_mode diffuse_toon, blend_add;

uniform vec3 color : source_color;

uniform sampler2D lightmap_texture : source_color, hint_default_white, repeat_disable, filter_linear_mipmap_anisotropic;
uniform vec4 lightmap_rect = vec4(0.0, 0.0, 1.0, 1.0);

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear;

void vertex() {
	float x1 = lightmap_rect.x;
	float y1 = lightmap_rect.y;
	float x2 = lightmap_rect.x + lightmap_rect.z;
	float y2 = lightmap_rect.y + lightmap_rect.w;
	UV2.x = (UV2.x * (x2 - x1)) + x1;
	UV2.y = (UV2.y * (y2 - y1)) + y1;
}

float proximity_fade(float fade_dst, sampler2D depth_texture, vec3 vertex, vec2 screen_uv, mat4 inv_proj_matrix) {
	float depth = textureLod(depth_texture, screen_uv, 0.0).r;
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
		depth *= 2.0;
		depth -= 1.0;
	#endif
	vec4 world_pos = inv_proj_matrix * vec4(screen_uv * 2.0 - 1.0, depth, 1.0);
	world_pos.xyz /= world_pos.w;

	return clamp(1.0 - smoothstep(world_pos.z + fade_dst, world_pos.z, vertex.z), 0.0, 1.0);
}

void fragment() {
	ALBEDO = color * texture(lightmap_texture, UV2).rgb * proximity_fade(1.0, DEPTH_TEXTURE, VERTEX, SCREEN_UV, INV_PROJECTION_MATRIX);
}

void light() {
	if (LIGHT_IS_DIRECTIONAL) {
		float NdotL = max(0.0, dot(NORMAL, LIGHT));
		DIFFUSE_LIGHT += NdotL * ATTENUATION * LIGHT_COLOR / PI;

		float NdotH = max(0.0, dot(NORMAL, normalize(VIEW + LIGHT)));
		float phong = pow(NdotH, 10.0) * ATTENUATION;

		float NdotV = dot(NORMAL, VIEW);
		float fresnel = 1.0 - max(0.0, NdotV);
		float NdotU = max(0.0, dot(NORMAL, vec3(0.0, 1.0, 0.0)));
		float rim = pow(fresnel, 3.0) * NdotU;

		SPECULAR_LIGHT += max(phong, rim) * ALBEDO * LIGHT_COLOR * SPECULAR_AMOUNT;
	}
}
