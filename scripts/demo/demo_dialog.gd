extends Window

@export var demo: DemoResource
@export var is_dev_demo: bool = false
@export var ghost_car: PackedScene

func _ready() -> void:
	$BG/VBox/WatchDemo.pressed.connect(watch_demo)
	$BG/VBox/GhostRace.pressed.connect(ghost_race)
	#$BG/VBox/Rename.pressed.connect(rename)
	#$BG/VBox/Delete.pressed.connect(delete)
	visibility_changed.connect(on_visibility_changed)
	close_requested.connect(hide)
	$BG/VBox/Cancel.pressed.connect(hide)

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

	$BG/VBox/Rename.disabled = is_dev_demo
	$BG/VBox/Delete.disabled = is_dev_demo
