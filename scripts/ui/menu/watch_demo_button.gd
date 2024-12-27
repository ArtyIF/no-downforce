extends Button

func _ready() -> void:
	DirAccess.make_dir_absolute("user://demos")
	pressed.connect(on_press)

func on_press() -> void:
	NoDownforceGlobal.ui_manager.windows["DemoDialog"].vs_ghost = false
	NoDownforceGlobal.ui_manager.show_window("DemoDialog")
