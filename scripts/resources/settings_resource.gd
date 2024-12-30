class_name SettingsResource extends Resource

@export var version: String = ProjectSettings.get_setting("application/config/version")

@export var controls: Dictionary[String, ControlResource] = {}

@export var audio_volumes: Dictionary[String, float] = {
	"Master": 1.0,
	"SFX": 1.0,
	"Engine": 1.0,
	"Background": 1.0,
	"UI": 1.0,
}

@export var graphics_window_mode: int = 2
@export var graphics_vsync: int = 1
@export var graphics_resolution_scale: float = 1.0
@export var graphics_upscaling_mode: int = 0
@export var graphics_msaa: int = 1
@export var graphics_fxaa: int = 1
@export var graphics_lighting_quality: int = 1
@export var graphics_reflection_probe_quality: int = 2
@export var graphics_shadow_resolution: int = 4
@export var graphics_shadow_filtering_quality: int = 5
@export var graphics_burnout_particles_quality: int = 5
@export var graphics_bloom_quality: int = 2
@export var graphics_fog_quality: int = 4
@export var graphics_ssao_quality: int = 4
@export var graphics_ssr_quality: int = 4

func set_default_controls():
	controls.clear()
	controls["aacc_forward"] = ControlResource.new()
	controls["aacc_backward"] = ControlResource.new()
	controls["aacc_steer_left"] = ControlResource.new()
	controls["aacc_steer_right"] = ControlResource.new()
	controls["aacc_handbrake"] = ControlResource.new()
	controls["aaccdemo_reset"] = ControlResource.new()
	
	var binding: InputEvent = null

	controls["aacc_forward"].deadzone = 0.05
	binding = InputEventKey.new()
	binding.physical_keycode = KEY_W
	controls["aacc_forward"].bindings.append(binding)
	binding = InputEventJoypadMotion.new()
	binding.axis = JOY_AXIS_TRIGGER_RIGHT
	binding.axis_value = 1.0
	controls["aacc_forward"].bindings.append(binding)

	controls["aacc_backward"].deadzone = 0.05
	binding = InputEventKey.new()
	binding.physical_keycode = KEY_S
	controls["aacc_backward"].bindings.append(binding)
	binding = InputEventJoypadMotion.new()
	binding.axis = JOY_AXIS_TRIGGER_LEFT
	binding.axis_value = 1.0
	controls["aacc_backward"].bindings.append(binding)

	controls["aacc_steer_left"].deadzone = 0.05
	binding = InputEventKey.new()
	binding.physical_keycode = KEY_A
	controls["aacc_steer_left"].bindings.append(binding)
	binding = InputEventJoypadMotion.new()
	binding.axis = JOY_AXIS_LEFT_X
	binding.axis_value = -1.0
	controls["aacc_steer_left"].bindings.append(binding)

	controls["aacc_steer_right"].deadzone = 0.05
	binding = InputEventKey.new()
	binding.physical_keycode = KEY_D
	controls["aacc_steer_right"].bindings.append(binding)
	binding = InputEventJoypadMotion.new()
	binding.axis = JOY_AXIS_LEFT_X
	binding.axis_value = 1.0
	controls["aacc_steer_right"].bindings.append(binding)

	controls["aacc_handbrake"].deadzone = 0.2
	binding = InputEventKey.new()
	binding.physical_keycode = KEY_SPACE
	controls["aacc_handbrake"].bindings.append(binding)
	binding = InputEventJoypadButton.new()
	binding.button_index = JOY_BUTTON_X
	controls["aacc_handbrake"].bindings.append(binding)

	controls["aaccdemo_reset"].deadzone = 0.2
	binding = InputEventKey.new()
	binding.physical_keycode = KEY_R
	controls["aaccdemo_reset"].bindings.append(binding)
	binding = InputEventJoypadButton.new()
	binding.button_index = JOY_BUTTON_BACK
	controls["aaccdemo_reset"].bindings.append(binding)

func load_controls():
	if not controls.is_empty():
		InputMap.action_set_deadzone("aacc_forward", controls["aacc_forward"].deadzone)
		InputMap.action_set_deadzone("aacc_backward", controls["aacc_backward"].deadzone)
		InputMap.action_set_deadzone("aacc_steer_left", controls["aacc_steer_left"].deadzone)
		InputMap.action_set_deadzone("aacc_steer_right", controls["aacc_steer_right"].deadzone)
		InputMap.action_set_deadzone("aacc_handbrake", controls["aacc_handbrake"].deadzone)
		InputMap.action_set_deadzone("aaccdemo_reset", controls["aaccdemo_reset"].deadzone)

		InputMap.action_erase_events("aacc_forward")
		for binding in controls["aacc_forward"].bindings:
			InputMap.action_add_event("aacc_forward", binding)

		InputMap.action_erase_events("aacc_backward")
		for binding in controls["aacc_backward"].bindings:
			InputMap.action_add_event("aacc_backward", binding)

		InputMap.action_erase_events("aacc_steer_left")
		for binding in controls["aacc_steer_left"].bindings:
			InputMap.action_add_event("aacc_steer_left", binding)

		InputMap.action_erase_events("aacc_steer_right")
		for binding in controls["aacc_steer_right"].bindings:
			InputMap.action_add_event("aacc_steer_right", binding)

		InputMap.action_erase_events("aacc_handbrake")
		for binding in controls["aacc_handbrake"].bindings:
			InputMap.action_add_event("aacc_handbrake", binding)

		InputMap.action_erase_events("aaccdemo_reset")
		for binding in controls["aaccdemo_reset"].bindings:
			InputMap.action_add_event("aaccdemo_reset", binding)

func update_controls():
	if controls.is_empty():
		set_default_controls()

	controls["aacc_forward"].deadzone = InputMap.action_get_deadzone("aacc_forward")
	controls["aacc_backward"].deadzone = InputMap.action_get_deadzone("aacc_backward")
	controls["aacc_steer_left"].deadzone = InputMap.action_get_deadzone("aacc_steer_left")
	controls["aacc_steer_right"].deadzone = InputMap.action_get_deadzone("aacc_steer_right")
	controls["aacc_handbrake"].deadzone = InputMap.action_get_deadzone("aacc_handbrake")
	controls["aaccdemo_reset"].deadzone = InputMap.action_get_deadzone("aaccdemo_reset")
	
	controls["aacc_forward"].bindings = InputMap.action_get_events("aacc_forward")
	controls["aacc_backward"].bindings = InputMap.action_get_events("aacc_backward")
	controls["aacc_steer_left"].bindings = InputMap.action_get_events("aacc_steer_left")
	controls["aacc_steer_right"].bindings = InputMap.action_get_events("aacc_steer_right")
	controls["aacc_handbrake"].bindings = InputMap.action_get_events("aacc_handbrake")
	controls["aaccdemo_reset"].bindings = InputMap.action_get_events("aaccdemo_reset")

func save():
	update_controls()
	ResourceSaver.save(self, "user://settings.tres")
