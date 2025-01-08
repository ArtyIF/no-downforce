extends Window

@export var demo: DemoResource
@export var is_dev_demo: bool = false
@export var ghost_car: PackedScene

func _ready() -> void:
	$BG/VBox/Options/WatchDemo.pressed.connect(watch_demo)
	$BG/VBox/Options/GhostRace.pressed.connect(ghost_race)
	$BG/VBox/Options/Rename.pressed.connect(rename)
	$BG/VBox/Options/Delete.pressed.connect(delete)
	$BG/VBox/Options/Cancel.pressed.connect(hide)

	$BG/VBox/RenameOptions/Rename.pressed.connect(rename_demo)
	$BG/VBox/RenameOptions/Cancel.pressed.connect(show_main_options)

	$BG/VBox/DeleteOptions/Delete.pressed.connect(delete_demo)
	$BG/VBox/DeleteOptions/Cancel.pressed.connect(show_main_options)

	visibility_changed.connect(on_visibility_changed)
	close_requested.connect(hide)

func watch_demo() -> void:
	hide()
	NoDownforceGlobal.demo_car_input.demo = demo
	NoDownforceGlobal.demo_car_input.custom_car = null
	NoDownforceGlobal.demo_car_input.load_demo()

func ghost_race() -> void:
	hide()
	NoDownforceGlobal.demo_car_input.demo = demo
	var ghost_instance: Car = ghost_car.instantiate()
	NoDownforceGlobal.demo_car_input.get_parent().add_child(ghost_instance)
	NoDownforceGlobal.demo_car_input.custom_car = ghost_instance
	NoDownforceGlobal.demo_car_input.load_demo(true, false)

func rename() -> void:
	$BG/VBox/Options.visible = false
	$BG/VBox/RenameOptions.visible = true
	$BG/VBox/DeleteOptions.visible = false
	call_deferred("set_size", Vector2i(400, 0))
	$BG/VBox/RenameOptions/RenameField.call_deferred("grab_focus")

func rename_demo() -> void:
	demo.name = $BG/VBox/RenameOptions/RenameField.text
	demo.save(demo.resource_path)
	on_visibility_changed()

func delete() -> void:
	$BG/VBox/Options.visible = false
	$BG/VBox/RenameOptions.visible = false
	$BG/VBox/DeleteOptions.visible = true
	call_deferred("set_size", Vector2i(400, 0))
	$BG/VBox/DeleteOptions/Cancel.call_deferred("grab_focus")

func delete_demo() -> void:
	DirAccess.remove_absolute(demo.resource_path)
	hide()

func show_main_options() -> void:
	$BG/VBox/Options.visible = true
	$BG/VBox/RenameOptions.visible = false
	$BG/VBox/DeleteOptions.visible = false
	call_deferred("set_size", Vector2i(400, 0))
	$BG/VBox/Options/GhostRace.call_deferred("grab_focus")

func on_visibility_changed() -> void:
	if not visible: return

	if demo.name == "":
		$BG/VBox/DemoInfo/Name.text = demo.resource_path.get_basename().get_file()
	else:
		$BG/VBox/DemoInfo/Name.text = demo.name
	$BG/VBox/DemoInfo/FilePath.visible = not is_dev_demo
	$BG/VBox/DemoInfo/FilePath.text = demo.resource_path.get_file()
	$BG/VBox/DemoInfo/Info/Time.text = NoDownforceGlobal.float_to_time(demo.length - demo.start_time)
	$BG/VBox/DemoInfo/Info/Version.text = "Version: " + demo.version

	$BG/VBox/Options/Rename.disabled = is_dev_demo
	$BG/VBox/Options/Delete.disabled = is_dev_demo
	
	show_main_options()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and visible:
		if $BG/VBox/Options.visible:
			hide()
		else:
			show_main_options()
