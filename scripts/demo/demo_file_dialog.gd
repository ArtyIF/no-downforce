extends FileDialog

@export var vs_ghost: bool = false
@export var ghost_car: PackedScene

func _ready() -> void:
	file_selected.connect(on_file_select)

func on_file_select(path: String) -> void:
	var resource: Resource = ResourceLoader.load(path)
	if not resource or resource is not DemoResource:
		NoDownforceGlobal.ui_manager.windows["ErrorDialog"].dialog_text = "The selected file is not a demo."
		NoDownforceGlobal.ui_manager.call_deferred("show_window", "ErrorDialog")
		return
	NoDownforceGlobal.demo_car_input.demo = resource
	if not vs_ghost:
		NoDownforceGlobal.demo_car_input.custom_car = null
		NoDownforceGlobal.demo_car_input.load_demo()
	else:
		var ghost_instance: Car = ghost_car.instantiate()
		NoDownforceGlobal.demo_car_input.get_parent().add_child(ghost_instance)
		NoDownforceGlobal.demo_car_input.custom_car = ghost_instance
		NoDownforceGlobal.demo_car_input.load_demo(true, false)
