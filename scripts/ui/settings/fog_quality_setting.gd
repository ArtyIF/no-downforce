extends OptionButton
@onready var world_env: WorldEnvironment = $"/root/RaceTrack/Lighting/WorldEnvironment"

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_fog_quality)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_fog_quality)

	if NoDownforceGlobal.using_opengl:
		set_item_disabled(1, true)
		set_item_disabled(2, true)
		set_item_disabled(3, true)
		set_item_disabled(4, true)
		get_parent().visible = false

func on_value_changed(index: int):
	if NoDownforceGlobal.using_opengl and index > 0:
		select(0)
		on_value_changed(0)
		return

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
	
	NoDownforceGlobal.settings_resource.graphics_fog_quality = index
