extends Control

func _process(_delta: float) -> void:
	for child in get_children():
		if child.visible:
			get_parent().visible = true
			return
	get_parent().visible = false
