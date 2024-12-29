class_name RaceTracker extends Node
@export var checkpoints_list: Array[Node3D]

@onready var _car: Car = AACCGlobal.current_car

@onready var _demo: DemoResource = DemoResource.new()

var save_requested: bool = false

func _init() -> void:
	NoDownforceGlobal.race_tracker = self

func reset(reset_demo: bool = false) -> void:
	if NoDownforceGlobal.showing_main_menu or (NoDownforceGlobal.playing_demo and not reset_demo):
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
	_demo.clear()
	save_requested = false
	if NoDownforceGlobal.demo_car_input.custom_car:
		NoDownforceGlobal.demo_car_input.load_demo(true, false)
	else:
		NoDownforceGlobal.demo_car_input.demo = null
		NoDownforceGlobal.demo_car_input.load_demo()

func _physics_process(delta: float) -> void:
	NoDownforceGlobal.update_timer(delta)

	AACCGlobal.current_car_input.enabled = (
		not NoDownforceGlobal.showing_main_menu and
		not (NoDownforceGlobal.playing_demo and not NoDownforceGlobal.demo_car_input.custom_car) and
		not NoDownforceGlobal.checkpoints_passed == NoDownforceGlobal.total_checkpoints
	)

	var playing_demo: bool = NoDownforceGlobal.playing_demo
	if NoDownforceGlobal.checkpoints_passed == NoDownforceGlobal.total_checkpoints:
		NoDownforceGlobal.ui_manager.hide_screen("HUD")
		NoDownforceGlobal.ui_manager.show_screen("OutroScreen")

		_car.input_forward = 0.0
		_car.input_backward = 0.0
		_car.input_handbrake = true
		_car.input_steer = 1.0
		
		if not save_requested:
			if not playing_demo:
				_demo.save()
			save_requested = true
	else:
		if not NoDownforceGlobal.timer_going and not _car.input_handbrake and (_car.input_forward > 0.0 or _car.input_backward > 0.0):
			NoDownforceGlobal.timer_going = true
			NoDownforceGlobal.ui_manager.show_screen("HUD")
			if playing_demo:
				NoDownforceGlobal.ui_manager.show_overlay("DemoOverlay")
			else:
				_demo.start_time = _demo.length
				if NoDownforceGlobal.demo_car_input.custom_car:
					NoDownforceGlobal.demo_car_input.playing = true
		if AACCGlobal.current_car_input.enabled:
			_demo.append(delta, _car.input_forward, _car.input_backward, _car.input_steer, _car.input_handbrake, _car.global_position, _car.global_rotation, _car.linear_velocity, _car.angular_velocity)
		elif _demo.length > 0.0:
			_demo.clear()
	
	if Input.is_action_pressed("aaccdemo_reset"):
		reset()
