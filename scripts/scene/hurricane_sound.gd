extends AudioStreamPlayer

var volume: SmoothedFloat = SmoothedFloat.new(0.1, 1.0, 2.0)

func _physics_process(delta: float) -> void:
	volume.advance_to(0.03 if NoDownforceGlobal.camera.global_position.y > 0.0 else 4.0, delta)
	volume_db = linear_to_db(volume.get_current_value())
