class_name DemoCarInput extends Node
@export var demo: DemoResource
@export var custom_car: Car

var current_frame: int = 0
var playing: bool = false
@onready var _car: Car = custom_car if custom_car else AACCGlobal.current_car

func _ready() -> void:
	NoDownforceGlobal.demo_car_input = self

func load_demo(start_from_takeoff: bool = false, autoplay: bool = true) -> void:
	NoDownforceGlobal.ui_manager.screens["HUD"].get_node("Time/VBox/TargetTime").visible = false
	NoDownforceGlobal.ui_manager.screens["HUD"].get_node("Time/VBox/TargetTimeLabel").visible = false
	if not demo:
		NoDownforceGlobal.ui_manager.hide_overlay("DemoOverlay")
		NoDownforceGlobal.playing_demo = false
		return
	if not demo.version.begins_with("0.5"):
		NoDownforceGlobal.ui_manager.windows["ErrorDialog"].dialog_text = "This demo is incompatible with this version of the game."
		NoDownforceGlobal.ui_manager.call_deferred("popup_window", "ErrorDialog")
		demo = null
		return

	_car = custom_car if custom_car else AACCGlobal.current_car
	_car.reset()
	current_frame = demo.start_frame if start_from_takeoff else 0
	NoDownforceGlobal.ui_manager.show_screen("IntroScreen")

	if not custom_car:
		NoDownforceGlobal.ui_manager.show_overlay("DemoOverlay")
		NoDownforceGlobal.playing_demo = true
	else:
		var time = demo.frames[len(demo.frames) - 1].time
		var minutes: int = floori(time / 60)
		var seconds: int = floori(time) % 60
		var milliseconds: int = floori(time * 1000) % 1000
		NoDownforceGlobal.ui_manager.screens["HUD"].get_node("Time/VBox/TargetTime").text = "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
		NoDownforceGlobal.ui_manager.screens["HUD"].get_node("Time/VBox/TargetTime").visible = true
		NoDownforceGlobal.ui_manager.screens["HUD"].get_node("Time/VBox/TargetTimeLabel").visible = true

	playing = autoplay

func _physics_process(_delta: float) -> void:
	if not _car: return
	if not demo:
		if not custom_car:
			_car.do_not_apply_forces = false
		else:
			NoDownforceGlobal.demo_car_input.custom_car.queue_free()
		return
	if current_frame >= len(demo.frames):
		if not custom_car:
			_car.do_not_apply_forces = false
		else:
			playing = false
			if _car.get_node("Engine").playing:
				_car.get_node("Engine").stop()
			_car.freeze = true
			_car.input_forward = 0.0
			_car.input_backward = 0.0
			_car.input_steer = 0.0
			_car.input_handbrake = 0.0
			_car.linear_velocity = Vector3.ZERO
			_car.angular_velocity = Vector3.ZERO
		return

	if current_frame >= 0:
		_car.do_not_apply_forces = true
		_car.input_forward = demo.frames[current_frame].forward
		_car.input_backward = demo.frames[current_frame].backward
		_car.input_steer = demo.frames[current_frame].steer
		_car.input_handbrake = demo.frames[current_frame].handbrake
		_car.global_position = demo.frames[current_frame].position
		_car.global_rotation = demo.frames[current_frame].rotation
		_car.linear_velocity = demo.frames[current_frame].linear_velocity
		_car.angular_velocity = demo.frames[current_frame].angular_velocity

	if playing:
		if custom_car:
			if not _car.get_node("Engine").playing:
				_car.get_node("Engine").play()
			_car.freeze = false
		current_frame += 1
	else:
		if custom_car and _car.get_node("Engine").playing:
			_car.get_node("Engine").stop()
