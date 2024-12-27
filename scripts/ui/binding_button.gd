extends Button

@export var control: String = ""

func _ready() -> void:
	pressed.connect(on_press)

func on_press():
	NoDownforceGlobal.ui_manager.windows["ControlBindingDialog"].control_to_change = control
	NoDownforceGlobal.ui_manager.popup_window("ControlBindingDialog")
