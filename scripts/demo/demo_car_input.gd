class_name DemoCarInput extends Node
@export var demo: DemoResource
@export var custom_car: Car

var current_frame: int = 0
var playing: bool = false
@onready var _car: Car = custom_car if custom_car else AACCGlobal.current_car

func _ready() -> void:
	NoDownforceGlobal.demo_car_input = self

func load_demo(start_from_takeoff: bool = false, autoplay: bool = true) -> void:
	if not demo:
		NoDownforceGlobal.ui_manager.hide_overlay("DemoOverlay")
		NoDownforceGlobal.playing_demo = false
		return
	if demo.version != "0.5":
		NoDownforceGlobal.ui_manager.windows["ErrorDialog"].dialog_text = "This demo is incompatible with this version of the game."
		NoDownforceGlobal.ui_manager.call_deferred("popup_window", "ErrorDialog")
		demo = null
		return

	_car = custom_car if custom_car else AACCGlobal.current_car
	_car.reset()
	current_frame = demo.start_frame if start_from_takeoff else 0
	if not custom_car:
		NoDownforceGlobal.ui_manager.show_screen("IntroScreen")
		NoDownforceGlobal.ui_manager.show_overlay("DemoOverlay")
		NoDownforceGlobal.playing_demo = true
	if autoplay:
		playing = true

func _physics_process(_delta: float) -> void:
	if not _car: return
	if not demo:
		_car.do_not_apply_forces = false
		return
	if current_frame >= len(demo.frames):
		_car.do_not_apply_forces = false
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
		current_frame += 1
