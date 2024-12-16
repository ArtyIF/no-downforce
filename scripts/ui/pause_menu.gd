extends Control

func _process(_delta: float) -> void:
	visible = get_tree().paused
	
	if Input.is_action_just_pressed("ui_cancel") and NoDownforceGlobal.timer_going:
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			$BG/HBox/ResumeButton.grab_focus()
