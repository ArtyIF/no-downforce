extends Button

func _ready() -> void:
	pressed.connect(on_press)

func on_press() -> void:
	get_tree().paused = false
	NoDownforceGlobal.ui_manager.show_screen("IntroScreen")
	NoDownforceGlobal.race_tracker.reset()
