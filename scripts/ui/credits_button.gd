extends Button

func _ready() -> void:
	pressed.connect(on_press)

func on_press() -> void:
	NoDownforceGlobal.ui_manager.show_window("CreditsDialog")
