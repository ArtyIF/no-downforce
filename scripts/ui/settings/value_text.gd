extends Label

func _process(delta: float) -> void:
	text = "%d%%" % roundi($"../Value".value * 100)
