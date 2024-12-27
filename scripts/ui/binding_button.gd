extends Button

@export var binding_to_change: String = ""

func _ready() -> void:
	pressed.connect(on_press)

func on_press():
	NoDownforceGlobal.ui_manager.windows["ControlBindingDialog"].binding_to_change = binding_to_change
	NoDownforceGlobal.ui_manager.popup_window("ControlBindingDialog")
