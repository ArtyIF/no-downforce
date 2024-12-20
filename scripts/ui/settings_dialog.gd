extends Window

func _ready() -> void:
	close_requested.connect(save_and_close)
	$BG/VBox/CloseButton.pressed.connect(save_and_close)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		save_and_close()

func save_and_close():
	NoDownforceGlobal.settings_resource.save()
	hide()
