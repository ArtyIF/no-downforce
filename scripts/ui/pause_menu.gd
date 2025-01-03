extends Control

func _process(_delta: float) -> void:
	visible = get_tree().paused
	
	if Input.is_action_just_pressed("ui_cancel") and not NoDownforceGlobal.showing_main_menu and not NoDownforceGlobal.ui_manager.windows["SettingsDialog"].visible:
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			$BG/HBox/ResumeButton.call_deferred("grab_focus")
			$BG/HBox/ResetButton.disabled = NoDownforceGlobal.playing_demo
		elif NoDownforceGlobal.playing_demo:
			NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PlaybackButtons/Pause").grab_focus()
