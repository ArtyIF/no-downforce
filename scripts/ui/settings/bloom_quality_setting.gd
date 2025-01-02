extends OptionButton
@onready var world_env: WorldEnvironment = $"/root/RaceTrack/Lighting/WorldEnvironment"

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_bloom_quality)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_bloom_quality)

	if NoDownforceGlobal.using_opengl:
		set_item_disabled(2, true)

func on_value_changed(index: int):
	if NoDownforceGlobal.using_opengl and index > 1:
		select(1)
		on_value_changed(1)
		return

	var env: Environment = world_env.environment
	match index:
		0:
			env.glow_enabled = false
		1:
			env.glow_enabled = true
			RenderingServer.environment_glow_set_use_bicubic_upscale(false)
		2:
			env.glow_enabled = true
			RenderingServer.environment_glow_set_use_bicubic_upscale(true)
	world_env.environment = env
	
	NoDownforceGlobal.settings_resource.graphics_bloom_quality = index
