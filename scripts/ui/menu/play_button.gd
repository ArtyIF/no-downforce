extends Button

func _ready() -> void:
	pressed.connect(on_press)

func on_press() -> void:
	NoDownforceGlobal.race_tracker.reset()
	NoDownforceGlobal.ui_manager.show_screen("IntroScreen")
	get_tree().paused = false
