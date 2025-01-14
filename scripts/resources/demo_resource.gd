class_name DemoResource extends Resource

@export var version: String = ProjectSettings.get_setting("application/config/version")
@export var name: String = ""
# KEEP FOR BACKWARDS COMPATIBILITY WITH 0.5
@export_storage var frames: Array[DemoFrame] = []
@export var frames_dict: Dictionary[float, Array] = {}
# KEEP FOR BACKWARDS COMPATIBILITY WITH 0.5
@export_storage var start_frame: int = 0
@export var start_time: float = 0.0
@export var length: float = 0.0

var _current_time: float = 0.0

func append(delta: float, forward: float, backward: float, steer: float, handbrake: bool, position: Vector3, rotation: Vector3, linear_velocity: Vector3, angular_velocity: Vector3, time: float = -1.0) -> void:
	if time >= 0.0:
		_current_time = time
	frames_dict[_current_time] = [
		forward,
		backward,
		steer,
		handbrake,
		position,
		rotation,
		linear_velocity,
		angular_velocity,
	]
	length = _current_time
	_current_time += delta

func save(file_path: String = "") -> Error:
	DirAccess.make_dir_absolute("user://demos")
	if version == "":
		version = ProjectSettings.get_setting("application/config/version")
	if len(frames_dict) == 0:
		print("Nothing to save")
		return ERR_INVALID_DATA
	if file_path == "":
		file_path = "user://demos/demo_%s.res" % str(Time.get_unix_time_from_system()).replace(".", "")
	var result = ResourceSaver.save(self, file_path)
	return result

func convert_from_05():
	if not version.begins_with("0.5"): return
	DirAccess.copy_absolute(resource_path, resource_path + ".bak")

	start_time = frames[start_frame - 1].time
	_current_time = 0.0
	for frame in frames:
		append(0.0, frame.forward, frame.backward, frame.steer, frame.handbrake, frame.position, frame.rotation, frame.linear_velocity, frame.angular_velocity, frame.time - 0.00833333)
	frames.clear()
	start_frame = 0
	version = "%s (recorded in %s)" % [ProjectSettings.get_setting("application/config/version"), version]
	save(resource_path)

func get_frame_at(time: float) -> DemoFrame:
	time = clamp(time, 0.0, length)

	var time_1: float = 0.0
	var time_2: float = 0.0
	var i: int = frames_dict.keys().bsearch(time)
	time_1 = frames_dict.keys()[max(0, i - 1)]
	time_2 = frames_dict.keys()[min(i, len(frames_dict.keys()) - 1)]

	var frame_1: Array = frames_dict[time_1]
	var frame_2: Array = frames_dict[time_2]
	var t: float = 0.0
	if time_1 != time_2:
		t = clamp(inverse_lerp(time_1, time_2, time), 0.0, 1.0)
	
	var lerped_basis: Basis = Basis.from_euler(frame_1[5]).slerp(Basis.from_euler(frame_2[5]), t)

	var result: DemoFrame = DemoFrame.new()
	result.time = time
	result.forward = lerp(frame_1[0], frame_2[0], t)
	result.backward = lerp(frame_1[1], frame_2[1], t)
	result.steer = lerp(frame_1[2], frame_2[2], t)
	result.handbrake = frame_1[3]
	result.position = frame_1[4].lerp(frame_2[4], t)
	result.rotation = lerped_basis.get_euler()
	result.linear_velocity = frame_1[6].lerp(frame_2[6], t)
	result.angular_velocity = frame_1[7].slerp(frame_2[7], t)
	return result

func clear() -> void:
	frames_dict.clear()
	_current_time = 0.0
