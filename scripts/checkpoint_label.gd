extends Label

func _process(_delta: float) -> void:
	text = "%d/5" % NoDownforceGlobal.checkpoints_passed
