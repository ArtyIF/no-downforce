class_name SettingsResource extends Resource

@export var version: String = ProjectSettings.get_setting("application/config/version")

@export var controls: Dictionary[StringName, ControlResource] = {}
static var rebindable_controls: Dictionary[StringName, String] = {
	"aacc_forward": "Accelerate",
	"aacc_backward": "Brake/Reverse",
	"aacc_steer_left": "Steer Left",
	"aacc_steer_right": "Steer Right",
	"aacc_handbrake": "Handbrake",
	"aaccdemo_reset": "Reset",
	"nd_camera_forward": "Camera Forward",
	"nd_camera_back": "Camera Back",
	"nd_camera_left": "Camera Left",
	"nd_camera_right": "Camera Right",
	"nd_camera_recenter": "Recenter Camera",
}

@export var audio_volumes: Dictionary[StringName, float] = {
	"Master": 1.0,
	"SFX": 1.0,
	"Engine": 1.0,
	"Background": 1.0,
	"UI": 1.0,
	"High Pitch": 1.0,
	"Harsh": 1.0,
	"Hurricane": 1.0,
}
@export var audio_qualities: Dictionary[StringName, AACCGlobal.SoundQuality] = {
	"Engine" = AACCGlobal.SoundQuality.ON,
	"TireScreech" = AACCGlobal.SoundQuality.ON,
	"Scrape" = AACCGlobal.SoundQuality.ON,
	"Collision" = AACCGlobal.SoundQuality.CURRENT_ONLY,
	"BrakeSqueal" = AACCGlobal.SoundQuality.CURRENT_ONLY,
	"TireRoll" = AACCGlobal.SoundQuality.CURRENT_ONLY,
}

@export var graphics_window_mode: int = 0
@export var graphics_vsync: int = 1
@export var graphics_resolution_scale: float = 1.0
@export var graphics_upscaling_mode: int = 0
@export var graphics_msaa: int = 1
@export var graphics_fxaa: int = 0
@export var graphics_lighting_quality: int = 1
@export var graphics_auto_exposure: int = 1
@export var graphics_reflection_probe_quality: int = 2
@export var graphics_shadow_resolution: int = 4
@export var graphics_shadow_filtering_quality: int = 5
@export var graphics_burnout_particles_quality: int = 5
@export var graphics_bloom_quality: int = 2
@export var graphics_fog_quality: int = 4
@export var graphics_ssao_quality: int = 2
@export var graphics_ssil_quality: int = 2
@export var graphics_ssr_quality: int = 2

@export var accessibility_saturation: float = 1.0
@export var accessibility_game_speed: float = 1.0
@export var accessibility_regular_font: int = 0

func load_controls():
	for key in rebindable_controls.keys():
		if controls.has(key):
			InputMap.action_set_deadzone(key, controls[key].deadzone)
			InputMap.action_erase_events(key)
			for binding in controls[key].bindings:
				InputMap.action_add_event(key, binding)

func update_controls():
	for key in rebindable_controls.keys():
		if not controls.has(key):
			controls[key] = ControlResource.new()
		controls[key].deadzone = InputMap.action_get_deadzone(key)
		controls[key].bindings = InputMap.action_get_events(key)

func save():
	update_controls()
	version = ProjectSettings.get_setting("application/config/version")
	ResourceSaver.save(self, "user://settings.tres")
