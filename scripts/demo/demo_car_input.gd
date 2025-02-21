class_name DemoCarInput extends Node
@export var demo: DemoResource
@export var custom_car: Car

var current_time: float = 0.0
var playback_speed: float = 1.0
@onready var _car: Car = custom_car if custom_car else AACCGlobal.current_car
var changing_time: bool = false

func position_slider_start_drag():
	changing_time = true

func position_slider_value_change(value: float):
	if changing_time:
		current_time = value
		NoDownforceGlobal.ui_manager.play_value_change_sound()

func position_slider_stop_drag(_value_changed: float):
	changing_time = false

func _ready() -> void:
	NoDownforceGlobal.demo_car_input = self
	
	await get_tree().process_frame
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PositionSlider").drag_started.connect(position_slider_start_drag)
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PositionSlider").value_changed.disconnect($"/root/UISoundAutoload".play_value_change_sound)
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PositionSlider").value_changed.connect(position_slider_value_change)
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PositionSlider").drag_ended.connect(position_slider_stop_drag)
	
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PlaybackButtons/GoBack").pressed.disconnect($"/root/UISoundAutoload".play_click_sound)
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PlaybackButtons/GoForward").pressed.disconnect($"/root/UISoundAutoload".play_click_sound)
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PlaybackButtons/GoBack").pressed.connect(go_back)
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PlaybackButtons/GoForward").pressed.connect(go_forward)

func go_back():
	current_time -= 1.0
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PositionSlider").value = current_time
	NoDownforceGlobal.ui_manager.play_value_change_sound()

func go_forward():
	current_time += 1.0
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PositionSlider").value = current_time
	NoDownforceGlobal.ui_manager.play_value_change_sound()

func load_demo(start_from_takeoff: bool = false, autoplay: bool = true) -> void:
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/SpeedHBox/Speed").select(2)
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PlaybackButtons/Rewind").button_pressed = false
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PlaybackButtons/Pause").button_pressed = false
	AACCGlobal.current_car.freeze = false
	NoDownforceGlobal.ui_manager.screens["HUD"].get_node("Time/VBox/TargetTime").visible = false

	if not demo:
		NoDownforceGlobal.playing_demo = false
		return

	if demo.version.is_empty() or demo.version.begins_with("0.1") or demo.version.begins_with("0.2") or demo.version.begins_with("0.3") or demo.version.begins_with("0.4"):
		NoDownforceGlobal.ui_manager.windows["ErrorDialog"].dialog_text = "This demo is incompatible with this version of the game."
		NoDownforceGlobal.ui_manager.call_deferred("popup_window", "ErrorDialog")
		demo = null
		return
	if demo.version.begins_with("0.5"):
		demo.convert_from_05()

	_car = custom_car if custom_car else AACCGlobal.current_car
	_car.reset()
	current_time = demo.start_time if start_from_takeoff else 0.0
	if start_from_takeoff:
		if demo.version.begins_with("0.5") or demo.version.begins_with("0.6"):
			current_time -= 1.0 / Engine.physics_ticks_per_second
		if not demo.version.contains("0.5") and (demo.version == "0.6.5" or demo.version == "0.6.6" or demo.version == "0.6.7" or demo.version == "0.6.8"):
			current_time += 1.0 / Engine.physics_ticks_per_second

	if not custom_car:
		if demo.name == "":
			NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/DemoName").text = demo.resource_path.get_basename().get_file()
		else:
			NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/DemoName").text = demo.name

		NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PositionSlider").max_value = demo.length
		NoDownforceGlobal.ui_manager.show_screen("DemoScreen")
		NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PlaybackButtons/Pause").call_deferred("grab_focus")
		NoDownforceGlobal.playing_demo = true
	else:
		NoDownforceGlobal.ui_manager.show_screen("IntroScreen")
		NoDownforceGlobal.ui_manager.screens["HUD"].get_node("Time/VBox/TargetTime/TargetTimeLabel").text = NoDownforceGlobal.float_to_time(demo.length - demo.start_time)
		NoDownforceGlobal.ui_manager.screens["HUD"].get_node("Time/VBox/TargetTime").visible = true

	playback_speed = 1.0 if autoplay else 0.0

func _physics_process(delta: float) -> void:
	if not _car: return
	if not demo:
		if not custom_car:
			_car.do_not_apply_forces = false
		else:
			NoDownforceGlobal.demo_car_input.custom_car.queue_free()
		return

	if current_time >= demo.length:
		playback_speed = 0.0
		_car.freeze = true
		var frame: DemoFrame = demo.get_frame_at(current_time)
		_car.input_forward = 0.0
		_car.input_backward = 0.0
		_car.input_steer = 0.0
		_car.input_handbrake = 0.0
		_car.global_position = frame.position
		_car.global_rotation = frame.rotation
		_car.linear_velocity = Vector3.ZERO
		_car.angular_velocity = Vector3.ZERO
	elif current_time >= 0.0:
		_car.do_not_apply_forces = true
		_car.freeze = false
		var frame: DemoFrame = demo.get_frame_at(current_time)
		_car.input_forward = frame.forward
		_car.input_backward = frame.backward
		_car.input_steer = frame.steer
		_car.input_handbrake = frame.handbrake
		_car.global_position = frame.position
		_car.global_rotation = frame.rotation
		_car.linear_velocity = frame.linear_velocity
		_car.angular_velocity = frame.angular_velocity

	if not custom_car:
		var selected_speed: int = NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/SpeedHBox/Speed").selected
		match selected_speed:
			0:
				playback_speed = 0.25
			1:
				playback_speed = 0.5
			2:
				playback_speed = 1.0
			3:
				playback_speed = 1.5
			4:
				playback_speed = 2.0
			5:
				playback_speed = 3.0
			6:
				playback_speed = 4.0
			7:
				playback_speed = 5.0
			8:
				playback_speed = 10.0
		playback_speed *= -1.0 if NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PlaybackButtons/Rewind").button_pressed else 1.0
		if NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PlaybackButtons/Pause").button_pressed:
			playback_speed = 0.0
	
	if changing_time:
		playback_speed = 0.0
	
	NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PositionText").text = NoDownforceGlobal.float_to_time(current_time) + " / " + NoDownforceGlobal.float_to_time(demo.length) 
	
	if playback_speed == 0.0:
		_car.freeze = true
	else:
		NoDownforceGlobal.ui_manager.screens["DemoScreen"].get_node("TopBG/VBox/PositionSlider").value = current_time
		current_time += delta * playback_speed
		current_time = clamp(current_time, 0.0, demo.length)
