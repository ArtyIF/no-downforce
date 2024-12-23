extends FileDialog

func _ready() -> void:
	file_selected.connect(on_file_select)

func on_file_select(path: String) -> void:
	var resource: Resource = ResourceLoader.load(path)
	if not resource or resource is not DemoResource:
		NoDownforceGlobal.ui_manager.windows["ErrorDialog"].dialog_text = "The selected file is not a demo."
		NoDownforceGlobal.ui_manager.call_deferred("popup_window", "ErrorDialog")
		return
	NoDownforceGlobal.demo_car_input.demo = resource
	NoDownforceGlobal.demo_car_input.load_demo()
