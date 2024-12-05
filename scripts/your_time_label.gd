extends Label

func _process(_delta: float) -> void:
	var time: float = NoDownforceGlobal.time_passed
	var minutes: int = floori(time / 60)
	var seconds: int = floori(time) % 60
	var milliseconds: int = floori(time * 1000) % 1000
	
	text = "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
