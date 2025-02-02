extends OptionButton
@onready var world_env: WorldEnvironment = $"/root/RaceTrack/Lighting/WorldEnvironment"

func _ready() -> void:
	item_selected.connect(on_value_changed)

	select(NoDownforceGlobal.settings_resource.graphics_ssil_quality)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_ssil_quality)
	
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
			env.ssil_enabled = false
		1:
			env.ssil_enabled = true
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_VERY_LOW, true, 0.5, 0, 50.0, 300.0)
		2:
			env.ssil_enabled = true
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_LOW, true, 0.5, 1, 50.0, 300.0)
		3:
			env.ssil_enabled = true
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_MEDIUM, true, 0.5, 2, 50.0, 300.0)
		4:
			env.ssil_enabled = true
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_HIGH, false, 0.5, 3, 50.0, 300.0)
	world_env.environment = env
	
	NoDownforceGlobal.settings_resource.graphics_ssil_quality = index
