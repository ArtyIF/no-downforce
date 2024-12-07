class_name DemoResource extends Resource

@export var version: String = ""
@export var frames: Array[Array] = []

func append(forward: float, backward: float, steer: float, handbrake: bool, transform: Transform3D, linear_velocity: Vector3, angular_velocity: Vector3) -> void:
	frames.append([forward, backward, steer, handbrake, transform, linear_velocity, angular_velocity])

func save() -> Error:
	if version == "":
		version = ProjectSettings.get_setting("application/config/version")
	var result = ResourceSaver.save(self, "user://save_%s.res" % str(Time.get_unix_time_from_system()).replace(".", ""))
	return result

func clear() -> void:
	frames.clear()
