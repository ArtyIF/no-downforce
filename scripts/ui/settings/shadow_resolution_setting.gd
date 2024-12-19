extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)

func on_value_changed(index: int):
	match index:
		0:
			$"/root/RaceTrack/Lighting/Sun".shadow_bias = 0.8
			RenderingServer.directional_shadow_atlas_set_size(512, true)
		1:
			$"/root/RaceTrack/Lighting/Sun".shadow_bias = 0.4
			RenderingServer.directional_shadow_atlas_set_size(1024, true)
		2:
			$"/root/RaceTrack/Lighting/Sun".shadow_bias = 0.2
			RenderingServer.directional_shadow_atlas_set_size(2048, true)
		3:
			$"/root/RaceTrack/Lighting/Sun".shadow_bias = 0.1
			RenderingServer.directional_shadow_atlas_set_size(4096, true)
		4:
			$"/root/RaceTrack/Lighting/Sun".shadow_bias = 0.05
			RenderingServer.directional_shadow_atlas_set_size(8192, true)
