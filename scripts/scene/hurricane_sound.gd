extends AudioStreamPlayer

var volume: SmoothedFloat = SmoothedFloat.new(0.1, 1.0, 2.0)

func _physics_process(delta: float) -> void:
	var target_volume: float = 0.02
	if NoDownforceGlobal.camera.global_position.y < 0.0:
		target_volume = 4.0
	elif AACCGlobal.current_car.ground_coefficient == 0.0: # TODO: get how far above ground the car is
		target_volume = 0.2 * min(AACCGlobal.current_car.linear_velocity.length() / 10.0, 1.0)
	volume.advance_to(target_volume, delta)
	volume_db = linear_to_db(volume.get_current_value())
