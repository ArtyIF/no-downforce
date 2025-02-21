extends ReflectionProbe

func _process(_delta: float) -> void:
	global_position = AACCGlobal.current_car.global_position + (AACCGlobal.current_car.global_basis.y * 0.25)
