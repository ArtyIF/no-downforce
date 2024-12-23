class_name DemoResource extends Resource

@export var version: String = ProjectSettings.get_setting("application/config/version")
@export var frames: Array[DemoFrame] = []
@export var start_frame: int = 0

var current_time: float = 0.0

func append(delta: float, forward: float, backward: float, steer: float, handbrake: bool, position: Vector3, rotation: Vector3, linear_velocity: Vector3, angular_velocity: Vector3) -> void:
	var frame = DemoFrame.new()
	frame.time = current_time
	frame.forward = forward
	frame.backward = backward
	frame.steer = steer
	frame.handbrake = handbrake
	frame.position = position
	frame.rotation = rotation
	frame.linear_velocity = linear_velocity
	frame.angular_velocity = angular_velocity
	frames.append(frame)
	current_time += delta

func save() -> Error:
	DirAccess.make_dir_absolute("user://demos")
	if version == "":
		version = ProjectSettings.get_setting("application/config/version")
	if len(frames) == 0:
		print("Nothing to save")
		return ERR_INVALID_DATA
	var result = ResourceSaver.save(self, "user://demos/demo_%s.res" % str(Time.get_unix_time_from_system()).replace(".", ""))
	return result

func clear() -> void:
	frames.clear()
	current_time = 0.0
