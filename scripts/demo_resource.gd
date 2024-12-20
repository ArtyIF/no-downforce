class_name DemoResource extends Resource

@export var version: String = ProjectSettings.get_setting("application/config/version")
@export var frames: Array[Array] = []
@export var start_frame: int = 0

func append(forward: float, backward: float, steer: float, handbrake: bool, transform: Transform3D, linear_velocity: Vector3, angular_velocity: Vector3) -> void:
	frames.append([forward, backward, steer, handbrake, transform, linear_velocity, angular_velocity])

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
