shader_type spatial;
render_mode diffuse_toon;

uniform sampler2D color_texture : source_color, hint_default_white, repeat_disable, filter_linear_mipmap_anisotropic;

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
	METALLIC = 0.5;
	SPECULAR = 1.0;
	ROUGHNESS = 0.0;

	ALBEDO = texture(color_texture, UV).rgb * texture(lightmap_texture, UV2).rgb;
}

void light() {
	float NdotL = max(0.0, dot(NORMAL, LIGHT));
	DIFFUSE_LIGHT += NdotL * ATTENUATION * LIGHT_COLOR / PI;

	float NdotH = max(0.0, dot(NORMAL, normalize(VIEW + LIGHT)));
	float phong = pow(NdotH, 10.0) * ATTENUATION;

	float rim = 0.0;
	if (LIGHT_IS_DIRECTIONAL) {
		float NdotV = dot(NORMAL, VIEW);
		float fresnel = 1.0 - clamp(NdotV, 0.0, 1.0);
		rim = pow(fresnel, 2.0) * mix(0.25, 1.0, NdotL * ATTENUATION);
	}
	
	SPECULAR_LIGHT += max(phong, rim) * ALBEDO * LIGHT_COLOR * SPECULAR_AMOUNT;
}