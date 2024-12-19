extends Button

func _ready() -> void:
	pressed.connect(on_press)

func on_press() -> void:
	NoDownforceGlobal.ui_manager.show_window("SettingsDialog")
	# TODO: use controls instead once that's ready
	NoDownforceGlobal.ui_manager.windows["SettingsDialog"].get_node("BG/VBox/Tabs").current_tab = 1
	NoDownforceGlobal.ui_manager.windows["SettingsDialog"].get_node("BG/VBox/Tabs/Audio/Scroll/List/Master/Value").grab_focus()
