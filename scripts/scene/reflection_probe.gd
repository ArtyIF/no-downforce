extends ReflectionProbe

func _process(delta: float) -> void:
	global_position = AACCGlobal.current_car.global_position + (AACCGlobal.current_car.global_basis.y * 0.25)
