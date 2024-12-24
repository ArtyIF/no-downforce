class_name SettingsResource extends Resource

@export var version: String = ProjectSettings.get_setting("application/config/version")

# TODO: controls

@export var audio_volumes: Dictionary[String, float] = {
	"Master": 1.0,
	"SFX": 1.0,
	"Engine": 1.0,
	"Background": 1.0,
	"UI": 1.0,
}

@export var graphics_window_mode: int = 0
@export var graphics_vsync: int = 1
@export var graphics_resolution_scale: float = 1.0
@export var graphics_upscaling_mode: int = 0
@export var graphics_msaa: int = 1
@export var graphics_fxaa: int = 1
@export var graphics_lighting_quality: int = 1
@export var graphics_reflection_probe_quality: int = 2
@export var graphics_shadow_resolution: int = 4
@export var graphics_shadow_filtering_quality: int = 5
@export var graphics_bloom_quality: int = 2
@export var graphics_fog_quality: int = 4
@export var graphics_ssao_quality: int = 4
@export var graphics_ssr_quality: int = 4

func save():
	ResourceSaver.save(self, "user://settings.tres")
