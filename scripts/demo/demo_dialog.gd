extends Window

@export var vs_ghost: bool = false
@export var dev_demos: Array[DemoResource] = []
@export var ghost_car: PackedScene

func _ready() -> void:
	visibility_changed.connect(on_visibility_changed)
	close_requested.connect(hide)
	$BG/VBox/BottomButtons/CancelButton.pressed.connect(hide)
	$BG/VBox/BottomButtons/FileDialogButton.pressed.connect(open_file_dialog)

func on_visibility_changed():
	if not visible: return
	title = "Race vs Ghost" if vs_ghost else "Watch Demo"

	for child in $BG/VBox/Scroll/List.get_children():
		if child.name != "HeaderTemplate" and child.name != "ButtonTemplate" and child.name != "NoUserDemos":
			child.queue_free()

	var dev_demos_header: Label = $BG/VBox/Scroll/List/HeaderTemplate.duplicate()
	dev_demos_header.text = "Developer Demos"
	dev_demos_header.visible = true
	$BG/VBox/Scroll/List.add_child(dev_demos_header)
	
	var first: bool = true
	for dev_demo in dev_demos:
		var dev_demos_button: PanelContainer = $BG/VBox/Scroll/List/ButtonTemplate.duplicate()
		dev_demos_button.get_node("Contents/VBox/Name").text = dev_demo.name
		dev_demos_button.get_node("Contents/VBox/Info/Time").text = NoDownforceGlobal.float_to_time(dev_demo.length - dev_demo.start_time)
		dev_demos_button.get_node("Contents/VBox/Info/Version").text = "Version: " + dev_demo.version
		dev_demos_button.get_node("Button").pressed.connect(load_demo.bind(dev_demo))
		dev_demos_button.visible = true
		$BG/VBox/Scroll/List.add_child(dev_demos_button)
		if first:
			dev_demos_button.get_node("Button").call_deferred("grab_focus")
			first = false
	
	var user_demos_header: Label = $BG/VBox/Scroll/List/HeaderTemplate.duplicate()
	user_demos_header.text = "User Demos"
	user_demos_header.visible = true
	$BG/VBox/Scroll/List.add_child(user_demos_header)
	
	var user_demos: Array[DemoResource] = []
	for user_demo_path in DirAccess.get_files_at("user://demos"):
		var user_demo = load("user://demos/" + user_demo_path)
		if user_demo is DemoResource:
			user_demo.convert_from_05()
			user_demos.append(user_demo)
	
	for user_demo in user_demos:
		var user_demos_button: PanelContainer = $BG/VBox/Scroll/List/ButtonTemplate.duplicate()
		if user_demo.name == "":
			user_demos_button.get_node("Contents/VBox/Name").text = user_demo.resource_path.get_basename().get_file()
		else:
			user_demos_button.get_node("Contents/VBox/Name").text = user_demo.name
		user_demos_button.get_node("Contents/VBox/Info/Time").text = NoDownforceGlobal.float_to_time(user_demo.length - user_demo.start_time)
		user_demos_button.get_node("Contents/VBox/Info/Version").text = "Version: " + user_demo.version
		user_demos_button.get_node("Button").pressed.connect(load_demo.bind(user_demo))
		user_demos_button.visible = true
		$BG/VBox/Scroll/List.add_child(user_demos_button)
		
	if user_demos.is_empty():
		$BG/VBox/Scroll/List.move_child($BG/VBox/Scroll/List/NoUserDemos, -1)
		$BG/VBox/Scroll/List/NoUserDemos.visible = true
	else:
		$BG/VBox/Scroll/List/NoUserDemos.visible = false

func load_demo(demo: DemoResource):
	hide()
	NoDownforceGlobal.demo_car_input.demo = demo
	if not vs_ghost:
		NoDownforceGlobal.demo_car_input.custom_car = null
		NoDownforceGlobal.demo_car_input.load_demo()
	else:
		var ghost_instance: Car = ghost_car.instantiate()
		NoDownforceGlobal.demo_car_input.get_parent().add_child(ghost_instance)
		NoDownforceGlobal.demo_car_input.custom_car = ghost_instance
		NoDownforceGlobal.demo_car_input.load_demo(true, false)

func open_file_dialog():
	hide()
	if NoDownforceGlobal.ui_manager.windows["DemoFileDialog"].root_subfolder != "demos":
		NoDownforceGlobal.ui_manager.windows["DemoFileDialog"].root_subfolder = "demos"
	NoDownforceGlobal.ui_manager.windows["DemoFileDialog"].vs_ghost = vs_ghost
	NoDownforceGlobal.ui_manager.show_window("DemoFileDialog")

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_cancel") and visible:
		hide()
