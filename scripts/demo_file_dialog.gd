extends FileDialog

func _ready() -> void:
	file_selected.connect(on_file_select)

func on_file_select(path: String) -> void:
	var resource: Resource = load(path)
	if resource is DemoResource:
		print("Loaded ", path)
		print(resource.version)
	else:
		push_error(path, " is not a DemoResource!")
	NoDownforceGlobal.demo_car_input.demo = resource
	NoDownforceGlobal.demo_car_input.load_demo()
