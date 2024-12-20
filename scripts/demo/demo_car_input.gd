class_name DemoCarInput extends Node
@export var demo: DemoResource
@export var apply_transform: bool = true
@export var apply_velocity: bool = true

var current_frame: int = 0
@onready var _car: Car = AACCGlobal.current_car

func _ready() -> void:
	NoDownforceGlobal.demo_car_input = self

func load_demo() -> void:
	current_frame = -1
	_car.reset()
	if not demo:
		NoDownforceGlobal.ui_manager.hide_overlay("DemoOverlay")
		NoDownforceGlobal.playing_demo = false
		return
	if demo.version != "0.5":
		NoDownforceGlobal.ui_manager.windows["ErrorDialog"].dialog_text = "The version of this demo is too old to be played properly."
		NoDownforceGlobal.ui_manager.call_deferred("popup_window", "ErrorDialog")
		demo = null
		return
	NoDownforceGlobal.ui_manager.show_screen("IntroScreen")
	NoDownforceGlobal.ui_manager.show_overlay("DemoOverlay")
	NoDownforceGlobal.playing_demo = true

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
		_car.input_forward = demo.frames[current_frame][0]
		_car.input_backward = demo.frames[current_frame][1]
		_car.input_steer = demo.frames[current_frame][2]
		_car.input_handbrake = demo.frames[current_frame][3]
		if len(demo.frames[current_frame]) > 4 and apply_transform:
			_car.global_transform = demo.frames[current_frame][4]
		if len(demo.frames[current_frame]) > 5 and apply_velocity:
			_car.linear_velocity = demo.frames[current_frame][5]
			_car.angular_velocity = demo.frames[current_frame][6]

	current_frame += 1
