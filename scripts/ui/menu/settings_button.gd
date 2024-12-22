extends Button

func _ready() -> void:
	pressed.connect(on_press)

func on_press() -> void:
	NoDownforceGlobal.ui_manager.popup_window("SettingsDialog")
	NoDownforceGlobal.ui_manager.windows["SettingsDialog"].get_node("BG/VBox/Tabs").current_tab = 0
	NoDownforceGlobal.ui_manager.windows["SettingsDialog"].get_node("BG/VBox/Tabs/Controls/ControllerType/Value").grab_focus()
