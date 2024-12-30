class_name RaceTracker extends Node
@export var checkpoints_list: Array[Node3D]

@onready var _car: Car = AACCGlobal.current_car

@onready var demo: DemoResource = DemoResource.new()

var _timer_nudged: bool = false

func _init() -> void:
	NoDownforceGlobal.race_tracker = self

func reset(force_reset: bool = false) -> void:
	if not force_reset and (NoDownforceGlobal.showing_main_menu or NoDownforceGlobal.playing_demo or NoDownforceGlobal.checkpoints_passed == NoDownforceGlobal.total_checkpoints):
		return

	_car.global_position = Vector3(0.0, 0.1, 0.0)
	_car.global_basis = Basis.IDENTITY
	_car.linear_velocity = Vector3.ZERO
	_car.angular_velocity = Vector3.ZERO
	_car.reset_physics_interpolation()
	_car.force_update_transform()
	_car.reset()
	
	NoDownforceGlobal.camera.reset()

	NoDownforceGlobal.ui_manager.show_screen("IntroScreen")
	
	NoDownforceGlobal.reset_race(checkpoints_list)
	_timer_nudged = false
	demo.clear()
	if NoDownforceGlobal.demo_car_input.custom_car:
		NoDownforceGlobal.demo_car_input.load_demo(true, false)
	else:
		NoDownforceGlobal.demo_car_input.demo = null
		NoDownforceGlobal.demo_car_input.load_demo()

func _physics_process(delta: float) -> void:
	AACCGlobal.current_car_input.enabled = (
		not NoDownforceGlobal.showing_main_menu and
		not (NoDownforceGlobal.playing_demo and not NoDownforceGlobal.demo_car_input.custom_car) and
		not NoDownforceGlobal.checkpoints_passed == NoDownforceGlobal.total_checkpoints
	)

	var playing_demo: bool = NoDownforceGlobal.playing_demo
	if NoDownforceGlobal.checkpoints_passed == NoDownforceGlobal.total_checkpoints:
		NoDownforceGlobal.timer_going = false
		
		if not _timer_nudged:
			NoDownforceGlobal.time_passed += delta
			_timer_nudged = true
		
		# HACK: the last frame isn't recorded, but if I do that, a lot of stuff
		# will have to be rewritten to account for it

		_car.input_forward = 0.0
		_car.input_backward = 0.0
		_car.input_handbrake = true
		_car.input_steer = 1.0
		
		if not playing_demo:
			NoDownforceGlobal.ui_manager.show_screen("OutroScreen")
			NoDownforceGlobal.time_passed = demo.length - demo.start_time
	else:
		if not NoDownforceGlobal.timer_going and not _car.input_handbrake and (_car.input_forward > 0.0 or _car.input_backward > 0.0):
			NoDownforceGlobal.timer_going = true
			NoDownforceGlobal.ui_manager.show_screen("HUD")
			if playing_demo:
				NoDownforceGlobal.ui_manager.show_overlay("DemoOverlay")
			else:
				demo.start_time = demo.length + (1.0 / Engine.physics_ticks_per_second)
				if NoDownforceGlobal.demo_car_input.custom_car:
					NoDownforceGlobal.demo_car_input.playing = true
		if AACCGlobal.current_car_input.enabled:
			demo.append(delta, _car.input_forward, _car.input_backward, _car.input_steer, _car.input_handbrake, _car.global_position, _car.global_rotation, _car.linear_velocity, _car.angular_velocity)
		elif demo.length > 0.0:
			demo.clear()

	NoDownforceGlobal.update_timer(delta)
	if Input.is_action_pressed("aaccdemo_reset"):
		reset()
