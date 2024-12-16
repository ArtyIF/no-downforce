extends ProgressBar

func _process(_delta: float) -> void:
	value = AACCGlobal.current_car.revs.get_current_value()
	modulate = Color(1.0, 2.66, 1.0) if value >= 1.0 else Color.WHITE
