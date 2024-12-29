extends Button

func _ready() -> void:
	pressed.connect(on_press)

func on_press() -> void:
	NoDownforceGlobal.race_tracker.reset(true)
	NoDownforceGlobal.ui_manager.show_screen("MainMenu")
	get_tree().paused = false
	NoDownforceGlobal.demo_car_input.demo = null
	NoDownforceGlobal.ui_manager.screens["MainMenu"].get_node("BG/HBox/RaceButton").call_deferred("grab_focus")
