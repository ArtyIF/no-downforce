extends Button

func _ready() -> void:
	DirAccess.make_dir_absolute("user://demos")
	pressed.connect(on_press)

func on_press() -> void:
	NoDownforceGlobal.ui_manager.windows["DemoFileDialog"].root_subfolder = "demos"
	NoDownforceGlobal.ui_manager.show_window("DemoFileDialog")
