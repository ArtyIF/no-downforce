extends ProgressBar

func _process(_delta: float) -> void:
	value = AACCGlobal.current_car.input_forward
