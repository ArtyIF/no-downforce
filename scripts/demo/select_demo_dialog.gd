extends Window

@export var dev_demos: Array[DemoResource] = []

func _ready() -> void:
	visibility_changed.connect(on_visibility_changed)
	close_requested.connect(hide)
	$BG/VBox/BottomButtons/CancelButton.pressed.connect(hide)
	$BG/VBox/BottomButtons/FileDialogButton.pressed.connect(open_file_dialog)

func on_visibility_changed():
	if not visible: return

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
		dev_demos_button.get_node("Contents/VBox/FilePath").visible = false
		dev_demos_button.get_node("Contents/VBox/Info/Time").text = NoDownforceGlobal.float_to_time(dev_demo.length - dev_demo.start_time)
		dev_demos_button.get_node("Contents/VBox/Info/Version").text = "Version: " + dev_demo.version
		dev_demos_button.get_node("Button").pressed.connect(select_demo.bind(dev_demo, true))
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
		if not user_demo_path.ends_with(".res") and not user_demo_path.ends_with(".tres"): continue
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
		user_demos_button.get_node("Contents/VBox/FilePath").visible = true
		user_demos_button.get_node("Contents/VBox/FilePath").text = user_demo.resource_path.get_file()
		user_demos_button.get_node("Contents/VBox/Info/Time").text = NoDownforceGlobal.float_to_time(user_demo.length - user_demo.start_time)
		user_demos_button.get_node("Contents/VBox/Info/Version").text = "Version: " + user_demo.version
		user_demos_button.get_node("Button").pressed.connect(select_demo.bind(user_demo, false))
		user_demos_button.visible = true
		$BG/VBox/Scroll/List.add_child(user_demos_button)
		
	if user_demos.is_empty():
		$BG/VBox/Scroll/List.move_child($BG/VBox/Scroll/List/NoUserDemos, -1)
		$BG/VBox/Scroll/List/NoUserDemos.visible = true
	else:
		$BG/VBox/Scroll/List/NoUserDemos.visible = false
	
	$BG/VBox/Scroll.set_deferred("scroll_vertical", 0)

func select_demo(demo: DemoResource, is_dev_demo: bool):
	hide()
	NoDownforceGlobal.ui_manager.windows["DemoDialog"].demo = demo
	NoDownforceGlobal.ui_manager.windows["DemoDialog"].is_dev_demo = is_dev_demo
	NoDownforceGlobal.ui_manager.popup_window("DemoDialog")

func open_file_dialog():
	hide()
	if NoDownforceGlobal.ui_manager.windows["LoadDemoFileDialog"].root_subfolder != "demos":
		NoDownforceGlobal.ui_manager.windows["LoadDemoFileDialog"].root_subfolder = "demos"
	NoDownforceGlobal.ui_manager.popup_window("LoadDemoFileDialog")

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_cancel") and visible:
		hide()
