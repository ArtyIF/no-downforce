class_name DemoResource extends Resource

@export var version: String = ""
@export var frames: Array[Array] = []

func append(forward: float, backward: float, steer: float, handbrake: bool) -> void:
	frames.append([forward, backward, steer, handbrake])

func save() -> Error:
	if version == "":
		version = ProjectSettings.get_setting("application/config/version")
	var result = ResourceSaver.save(self, "user://save_%s.res" % str(Time.get_unix_time_from_system()).replace(".", ""))
	return result

func clear() -> void:
	frames.clear()
