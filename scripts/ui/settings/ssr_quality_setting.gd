extends OptionButton
@onready var world_env: WorldEnvironment = $"/root/RaceTrack/Lighting/WorldEnvironment"

func _ready() -> void:
	item_selected.connect(on_value_changed)

func on_value_changed(index: int):
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
