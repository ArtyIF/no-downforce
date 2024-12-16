extends FileDialog

func _ready() -> void:
	file_selected.connect(on_file_select)

func on_file_select(path: String) -> void:
	var resource: Resource = load(path)
	if resource is DemoResource:
		print("Loaded ", path)
		print(resource.version)
	else:
		NoDownforceGlobal.ui_manager.windows["ErrorDialog"].dialog_text = "You've tried loading a file that's not a demo resource."
		NoDownforceGlobal.ui_manager.call_deferred("popup_window", "ErrorDialog")
	NoDownforceGlobal.demo_car_input.demo = resource
	NoDownforceGlobal.demo_car_input.load_demo()
