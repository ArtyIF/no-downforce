extends Label

func _process(_delta: float) -> void:
	if NoDownforceGlobal.playing_demo:
		text = NoDownforceGlobal.float_to_time(max(0.0, NoDownforceGlobal.demo_car_input.current_time - NoDownforceGlobal.demo_car_input.demo.start_time))
	else:
		text = NoDownforceGlobal.float_to_time(NoDownforceGlobal.time_passed)
