class_name NoDownforceCamera extends Camera3D

@export var follow_camera_position: Node3D
@export var lookat_camera_position: Node3D

func _ready() -> void:
	NoDownforceGlobal.camera = self

func reset() -> void:
	follow_camera_position.reset()
	lookat_camera_position.reset()
	reset_physics_interpolation()

func _physics_process(_delta: float) -> void:
	global_transform = Transform3D(Basis.IDENTITY, follow_camera_position.global_position).looking_at(lookat_camera_position.global_position, follow_camera_position.up_direction)
