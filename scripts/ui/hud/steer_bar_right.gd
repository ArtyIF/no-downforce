extends ProgressBar

func _process(_delta: float) -> void:
	value = min(1.0, AACCGlobal.current_car.input_steer)
