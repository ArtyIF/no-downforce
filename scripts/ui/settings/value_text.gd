extends Label

func _process(_delta: float) -> void:
	text = "%d%%" % roundi($"../Value".value * 100)
