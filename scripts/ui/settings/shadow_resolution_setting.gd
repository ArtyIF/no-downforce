extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_shadow_resolution)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_shadow_resolution)

func on_value_changed(index: int):
	match index:
		0:
			$"/root/RaceTrack/Lighting/Sun".directional_shadow_mode = DirectionalLight3D.ShadowMode.SHADOW_ORTHOGONAL
			$"/root/RaceTrack/Lighting/Sun".directional_shadow_max_distance = 0.001
			RenderingServer.directional_shadow_atlas_set_size(256, true)
		1:
			$"/root/RaceTrack/Lighting/Sun".directional_shadow_mode = DirectionalLight3D.ShadowMode.SHADOW_PARALLEL_4_SPLITS
			$"/root/RaceTrack/Lighting/Sun".directional_shadow_max_distance = 20.0
			$"/root/RaceTrack/Lighting/Sun".shadow_bias = 0.8
			RenderingServer.directional_shadow_atlas_set_size(512, true)
		2:
			$"/root/RaceTrack/Lighting/Sun".directional_shadow_mode = DirectionalLight3D.ShadowMode.SHADOW_PARALLEL_4_SPLITS
			$"/root/RaceTrack/Lighting/Sun".directional_shadow_max_distance = 20.0
			$"/root/RaceTrack/Lighting/Sun".shadow_bias = 0.4
			RenderingServer.directional_shadow_atlas_set_size(1024, true)
		3:
			$"/root/RaceTrack/Lighting/Sun".directional_shadow_mode = DirectionalLight3D.ShadowMode.SHADOW_PARALLEL_4_SPLITS
			$"/root/RaceTrack/Lighting/Sun".directional_shadow_max_distance = 20.0
			$"/root/RaceTrack/Lighting/Sun".shadow_bias = 0.2
			RenderingServer.directional_shadow_atlas_set_size(2048, true)
		4:
			$"/root/RaceTrack/Lighting/Sun".directional_shadow_mode = DirectionalLight3D.ShadowMode.SHADOW_PARALLEL_4_SPLITS
			$"/root/RaceTrack/Lighting/Sun".directional_shadow_max_distance = 20.0
			$"/root/RaceTrack/Lighting/Sun".shadow_bias = 0.1
			RenderingServer.directional_shadow_atlas_set_size(4096, true)

	NoDownforceGlobal.settings_resource.graphics_shadow_resolution = index
