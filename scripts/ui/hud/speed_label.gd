extends Label

func _process(_delta: float) -> void:
	if NoDownforceGlobal.settings_resource.gameplay_speed_unit == 1:
		text = str(int(AACCGlobal.current_car.linear_velocity.length() * 2.237))
	else:
		text = str(int(AACCGlobal.current_car.linear_velocity.length() * 3.6))
