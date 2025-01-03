extends Button

func _ready() -> void:
	pressed.connect(on_press)

func on_press() -> void:
	get_tree().paused = false
	if NoDownforceGlobal.playing_demo:
		NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PlaybackButtons/Pause").grab_focus()
