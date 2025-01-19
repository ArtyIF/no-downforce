extends WorldEnvironment

var fade_amount: SmoothedFloat = SmoothedFloat.new(0.0, 1.0, 1.0)

func _process(delta: float) -> void:
	fade_amount.advance_to(0.0 if NoDownforceGlobal.camera.global_position.y > 0.0 else 1.0, delta)
	var env: Environment = environment
	env.fog_density = lerp(0.0025, 0.25, fade_amount.get_current_value())
	env.fog_height_density = lerp(0.5, 0.0, fade_amount.get_current_value())
	env.fog_sky_affect = lerp(0.25, 1.0, fade_amount.get_current_value())
	environment = env
