extends Range
@onready var world_env: WorldEnvironment = $"/root/RaceTrack/Lighting/WorldEnvironment"

func _ready() -> void:
	value_changed.connect(on_value_changed)
	value = NoDownforceGlobal.settings_resource.accessibility_saturation
	on_value_changed(NoDownforceGlobal.settings_resource.accessibility_saturation)

func on_value_changed(value: float):
	var env: Environment = world_env.environment
	env.adjustment_saturation = value
	world_env.environment = env
	
	NoDownforceGlobal.settings_resource.accessibility_saturation = value
