extends Node

var checkpoints_passed: int = 0
var total_checkpoints: int = 5
var time_passed: float = 0.0
var timer_going: bool = false
var demo_car_input: DemoCarInput
var playing_demo: bool = false
var showing_main_menu: bool = false
var ui_manager: UIManager
var camera: NoDownforceCamera
var race_tracker: RaceTracker
var settings_resource: SettingsResource

@onready var using_opengl: bool = ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method") == "gl_compatibility"

func _ready() -> void:
	if not FileAccess.file_exists("user://settings.tres"):
		settings_resource = SettingsResource.new()
	else:
		settings_resource = ResourceLoader.load("user://settings.tres", "", ResourceLoader.CACHE_MODE_REPLACE)
		settings_resource.load_controls()
	settings_resource.save()

func activate_next_checkpoint(current: Node3D, next: Node3D):
	checkpoints_passed += 1

	current.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	current.visible = false

	if checkpoints_passed < total_checkpoints:
		next.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
		race_tracker.get_node("CheckpointPass").play()
		next.visible = true
	else:
		race_tracker.get_node("CheckpointFinish").play()
		timer_going = false

func reset_race(checkpoints_list: Array[Node3D]):
	for checkpoint in checkpoints_list:
		checkpoint.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		checkpoint.visible = false

	checkpoints_list[0].set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)

	checkpoints_passed = 0
	time_passed = 0.0
	timer_going = false

func update_timer(delta: float):
	if timer_going:
		time_passed += delta

func input_event_as_string(input: InputEvent) -> String:
	var result: String = "Unsupported!"

	if input is InputEventKey:
		result = input.as_text_keycode() + " (Keyboard)"
	elif input is InputEventJoypadMotion:
		var axis_string: String = "???"
		match input.axis:
			JOY_AXIS_LEFT_X:
				if input.axis_value < 0.0:
					axis_string = "LS Left"
				elif input.axis_value > 0.0:
					axis_string = "LS Right"
			JOY_AXIS_LEFT_Y:
				if input.axis_value < 0.0:
					axis_string = "LS Up"
				elif input.axis_value > 0.0:
					axis_string = "LS Down"
			JOY_AXIS_RIGHT_X:
				if input.axis_value < 0.0:
					axis_string = "RS Left"
				elif input.axis_value > 0.0:
					axis_string = "RS Right"
			JOY_AXIS_RIGHT_Y:
				if input.axis_value < 0.0:
					axis_string = "RS Up"
				elif input.axis_value > 0.0:
					axis_string = "RS Down"
			JOY_AXIS_TRIGGER_LEFT:
				axis_string = "LT/L2"
			JOY_AXIS_TRIGGER_RIGHT:
				axis_string = "RT/R2"
		result = axis_string + " (Gamepad)"
	elif input is InputEventJoypadButton:
		var button_string: String = "???"
		match input.button_index:
			JOY_BUTTON_A:
				button_string = "A/Cross"
			JOY_BUTTON_B:
				button_string = "B/Circle"
			JOY_BUTTON_X:
				button_string = "X/Square"
			JOY_BUTTON_Y:
				button_string = "Y/Triangle"
			JOY_BUTTON_BACK:
				button_string = "View/Back/Select"
			JOY_BUTTON_GUIDE:
				button_string = "Xbox/PS"
			JOY_BUTTON_START:
				button_string = "Menu/Start/Options"
			JOY_BUTTON_LEFT_STICK:
				button_string = "LS Click/L3"
			JOY_BUTTON_RIGHT_STICK:
				button_string = "RS Click/R3"
			JOY_BUTTON_LEFT_SHOULDER:
				button_string = "LB/L1"
			JOY_BUTTON_RIGHT_SHOULDER:
				button_string = "RB/R1"
			JOY_BUTTON_DPAD_UP:
				button_string = "D-Pad Up"
			JOY_BUTTON_DPAD_DOWN:
				button_string = "D-Pad Down"
			JOY_BUTTON_DPAD_LEFT:
				button_string = "D-Pad Left"
			JOY_BUTTON_DPAD_RIGHT:
				button_string = "D-Pad Right"
			JOY_BUTTON_MISC1:
				button_string = "Share/Microphone"
			JOY_BUTTON_PADDLE1:
				button_string = "Upper Right Paddle"
			JOY_BUTTON_PADDLE2:
				button_string = "Upper Left Paddle"
			JOY_BUTTON_PADDLE3:
				button_string = "Lower Right Paddle"
			JOY_BUTTON_PADDLE4:
				button_string = "Lower Left Paddle"
			JOY_BUTTON_TOUCHPAD:
				button_string = "Touchpad Click"
		result = button_string + " (Gamepad)"

	return result

func float_to_time(time: float) -> String:
	var minutes: int = floori(time / 60)
	var seconds: int = floori(time) % 60
	var milliseconds: int = floori(time * 1000) % 1000
	
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
