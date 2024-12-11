extends Label

func _process(_delta: float) -> void:
	text = str(int(AACCGlobal.current_car.linear_velocity.length() * 3.6))
