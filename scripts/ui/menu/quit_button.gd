extends Button

func _ready() -> void:
	pressed.connect(on_press)
	get_tree().set_auto_accept_quit(false)
	visible = not OS.has_feature("web")

func on_press() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func _notification(what: int):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()
