extends Label

func _process(_delta: float) -> void:
	text = NoDownforceGlobal.float_to_time(NoDownforceGlobal.time_passed)
