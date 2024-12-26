extends Node3D

@onready var _car: Car = AACCGlobal.current_car

@onready var _offset_node_min: Node3D = _car.get_node("FollowCameraOffsetMin")
@onready var _offset_node_max: Node3D = _car.get_node("FollowCameraOffsetMax")
@onready var _offset_amount: float = 0.0

var _forward_offset_amount: float = 0.0
@onready var _up_direction: Vector3 = Vector3.UP
@onready var _y_position: float = global_position.y
@onready var _original_y_position: float = _y_position

func reset():
	_offset_amount = 0.0
	_forward_offset_amount = 0.0
	_up_direction = Vector3.UP
	_y_position = _original_y_position

func _physics_process(delta: float) -> void:
	var global_com: Vector3 = _car.to_global(_car.center_of_mass)
	var final_position: Vector3 = global_com
	
	var target_up_direction: Vector3 = Vector3.UP
	if _car.ground_coefficient > 0.0:
		target_up_direction = _car.average_wheel_collision_normal
	if _up_direction.distance_to(target_up_direction) > 0.001:
		_up_direction = _up_direction.slerp(target_up_direction, delta)
	else:
		_up_direction = target_up_direction

	var target_offset_amount: float = (_car.linear_velocity.length() - 0.25) / 100.0
	_offset_amount = lerp(_offset_amount, target_offset_amount, 2.0 * delta)
	var offset: Vector3 = _offset_node_min.position.lerp(_offset_node_max.position, _offset_amount)

	final_position += _up_direction * offset.y
	
	var target_forward_offset_amount: float = min(_car.linear_velocity.length() / 10.0, 1.0) * sign(_car.local_linear_velocity.z)
	target_forward_offset_amount *= _car.ground_coefficient
	if _car.input_handbrake:
		target_forward_offset_amount = 0.0
	_forward_offset_amount = lerp(_forward_offset_amount, target_forward_offset_amount, 4.0 * delta)

	final_position += Plane(_up_direction).project(_car.global_basis.z) * 1.5 * _forward_offset_amount

	_y_position = lerp(_y_position, final_position.y, 40.0 * delta)
	final_position.y = _y_position
	global_position = final_position
