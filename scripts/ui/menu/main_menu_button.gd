extends Button

func _ready() -> void:
	pressed.connect(on_press)

func on_press() -> void:
	NoDownforceGlobal.race_tracker.reset()
	NoDownforceGlobal.ui_manager.show_screen("MainMenu")
	get_tree().paused = false
	NoDownforceGlobal.ui_manager.screens["MainMenu"].get_node("BG/HBox/RaceAloneButton").grab_focus()
