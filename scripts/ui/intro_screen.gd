extends Control

func _process(_delta: float) -> void:
	if visible and not NoDownforceGlobal.playing_demo and Input.is_action_pressed("ui_cancel"):
		NoDownforceGlobal.ui_manager.show_screen("MainMenu")
		NoDownforceGlobal.ui_manager.screens["MainMenu"].get_node("BG/HBox/RaceButton").grab_focus()
		NoDownforceGlobal.demo_car_input.demo = null
