extends OptionButton
@onready var world_env: WorldEnvironment = $"/root/RaceTrack/Lighting/WorldEnvironment"

func _ready() -> void:
	item_selected.connect(on_value_changed)

func on_value_changed(index: int):
	var env: Environment = world_env.environment
	match index:
		0:
			env.fog_enabled = true
			env.volumetric_fog_enabled = false
		1:
			env.fog_enabled = false
			env.volumetric_fog_enabled = true
			RenderingServer.environment_set_volumetric_fog_volume_size(16, 16)
		2:
			env.fog_enabled = false
			env.volumetric_fog_enabled = true
			RenderingServer.environment_set_volumetric_fog_volume_size(32, 32)
		3:
			env.fog_enabled = false
			env.volumetric_fog_enabled = true
			RenderingServer.environment_set_volumetric_fog_volume_size(64, 64)
		4:
			env.fog_enabled = false
			env.volumetric_fog_enabled = true
			RenderingServer.environment_set_volumetric_fog_volume_size(128, 128)
	world_env.environment = env
