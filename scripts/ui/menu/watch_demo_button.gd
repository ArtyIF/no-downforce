extends Button

func _ready() -> void:
	DirAccess.make_dir_absolute("user://demos")
	pressed.connect(on_press)

func on_press() -> void:
	if NoDownforceGlobal.ui_manager.windows["DemoFileDialog"].root_subfolder != "demos":
		NoDownforceGlobal.ui_manager.windows["DemoFileDialog"].root_subfolder = "demos"
	NoDownforceGlobal.ui_manager.windows["DemoFileDialog"].vs_ghost = false
	NoDownforceGlobal.ui_manager.show_window("DemoFileDialog")
