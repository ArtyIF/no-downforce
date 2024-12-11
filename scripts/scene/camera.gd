class_name NoDownforceCamera extends Camera3D

@onready var _car: Car = AACCGlobal.current_car
@onready var _last_position: Vector3 = _car.get_global_transform_interpolated().origin

@onready var _direction_target: Vector3 = _car.global_basis.z
@onready var _smoothed_direction: Vector3 = _car.global_basis.z

@onready var _starting_position: Vector3 = global_position
@onready var _starting_basis: Basis = global_basis

var _up_vector_target: Vector3 = Vector3.UP
var _smoothed_up_vector: Vector3 = Vector3.UP
var _follow_amount: float = 0.0
var follow_amount_speed: float = 0.0

func _ready() -> void:
	process_priority = 1000
	NoDownforceGlobal.camera = self

func reset() -> void:
	_last_position = _car.get_global_transform_interpolated().origin

	_direction_target = _car.global_basis.z
	_smoothed_direction = _car.global_basis.z

	_up_vector_target = Vector3.UP
	_smoothed_up_vector = Vector3.UP

	_follow_amount = 0.0
	follow_amount_speed = 0.0

func _physics_process(delta: float) -> void:
	var car_position: Vector3 = _car.global_position
	
	if _car.ground_coefficient > 0.0:
		_up_vector_target = _car.average_wheel_collision_normal
	else:
		_up_vector_target = Vector3.UP
	
	if _smoothed_up_vector.distance_to(_up_vector_target) > 0.001:
		_smoothed_up_vector = _smoothed_up_vector.slerp(_up_vector_target, delta)
	else:
		_smoothed_up_vector = _up_vector_target
	var project_plane: Plane = Plane(_smoothed_up_vector)
	
	var velocity: Vector3 = (_last_position - car_position) / delta
	velocity = project_plane.project(velocity)
	var smooth_amount: float = clamp(remap(velocity.length(), 0.0, 10.0, 0.0, 10.0), 0.0, 10.0)

	_direction_target = velocity.normalized()

	_smoothed_direction = _smoothed_direction.slerp(_direction_target, delta * smooth_amount)
	_smoothed_direction = project_plane.project(_smoothed_direction).normalized()
	global_basis = Basis.looking_at(-_smoothed_direction, _smoothed_up_vector)
	
	var follow_camera_offset: Vector3 = _car.get_node("FollowCameraOffset").position
	global_position = car_position + (_smoothed_direction * lerp(follow_camera_offset.z, follow_camera_offset.z + 2.0, min(velocity.length() / 100.0, 1.0))) + (_smoothed_up_vector * follow_camera_offset.y)
	
	global_position = _starting_position.lerp(global_position, ease(_follow_amount, -2.0))
	global_basis = _starting_basis.slerp(global_basis, ease(_follow_amount, -2.0))

	_last_position = car_position

	_follow_amount += delta * follow_amount_speed
	_follow_amount = min(_follow_amount, 1.0)
