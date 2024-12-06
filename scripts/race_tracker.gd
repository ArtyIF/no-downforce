extends Node
@export var checkpoints_list: Array[Node3D]

@onready var _car: Car = AACCGlobal.current_car

@onready var _demo: DemoResource = DemoResource.new()

var save_requested: bool = false

func reset() -> void:
	_car.global_position = Vector3(0.0, 0.1, 0.0)
	_car.global_basis = Basis.IDENTITY
	_car.linear_velocity = Vector3.ZERO
	_car.angular_velocity = Vector3.ZERO
	_car.force_update_transform()
	_car.reset_physics_interpolation()
	_car.reset()
	
	get_node("../Camera").reset()
	
	get_node("../UI/IntroScreen").visible = true
	get_node("../UI/HUD").visible = false
	get_node("../UI/OutroScreen").visible = false
	
	NoDownforceGlobal.reset_race(checkpoints_list)
	_demo.clear()

func _physics_process(delta: float) -> void:
	if NoDownforceGlobal.checkpoints_passed == NoDownforceGlobal.total_checkpoints:
		get_node("../Camera").follow_amount_speed = -1.0
		get_node("../CarInput").process_mode = Node.PROCESS_MODE_DISABLED
		get_node("../HUD").visible = false
		get_node("../UI/OutroScreen").visible = true

		_car.input_forward = 0.0
		_car.input_backward = 0.0
		_car.input_handbrake = true
		_car.input_steer = 1.0
		
		if not save_requested:
			_demo.save()
			save_requested = true
	else:
		get_node("../CarInput").process_mode = Node.PROCESS_MODE_INHERIT
		if not NoDownforceGlobal.timer_going and not _car.input_handbrake and (_car.input_forward > 0.0 or _car.input_backward > 0.0):
			get_node("../Camera").follow_amount_speed = 1.0
			NoDownforceGlobal.timer_going = true
			get_node("../UI/IntroScreen").visible = false
			get_node("../UI/HUD").visible = true
			get_node("../UI/OutroScreen").visible = false
		_demo.append(_car.input_forward, _car.input_backward, _car.input_steer, _car.input_handbrake, _car.global_transform)

	NoDownforceGlobal.update_timer(delta)
	
	if Input.is_action_pressed("aaccdemo_reset"):
		reset()
