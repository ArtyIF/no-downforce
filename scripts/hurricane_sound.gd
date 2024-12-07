extends AudioStreamPlayer

var volume: SmoothedFloat = SmoothedFloat.new(0.1, 1.0, 4.0)

func _physics_process(delta: float) -> void:
	volume.advance_to(0.1 if AACCGlobal.current_car.global_position.y > -5.0 else 4.0, delta)
	volume_db = linear_to_db(volume.get_current_value())
