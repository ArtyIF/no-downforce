extends OptionButton
@onready var world_env: WorldEnvironment = $"/root/RaceTrack/Lighting/WorldEnvironment"

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_ssr_quality)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_ssr_quality)
	
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
			env.ssr_enabled = false
		1:
			env.ssr_enabled = true
			RenderingServer.environment_set_ssr_roughness_quality(RenderingServer.ENV_SSR_ROUGHNESS_QUALITY_DISABLED)
		2:
			env.ssr_enabled = true
			RenderingServer.environment_set_ssr_roughness_quality(RenderingServer.ENV_SSR_ROUGHNESS_QUALITY_LOW)
		3:
			env.ssr_enabled = true
			RenderingServer.environment_set_ssr_roughness_quality(RenderingServer.ENV_SSR_ROUGHNESS_QUALITY_MEDIUM)
		4:
			env.ssr_enabled = true
			RenderingServer.environment_set_ssr_roughness_quality(RenderingServer.ENV_SSR_ROUGHNESS_QUALITY_HIGH)
	world_env.environment = env
	
	NoDownforceGlobal.settings_resource.graphics_ssr_quality = index
