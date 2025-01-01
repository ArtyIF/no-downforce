extends OptionButton
@onready var world_env: WorldEnvironment = $"/root/RaceTrack/Lighting/WorldEnvironment"

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_auto_exposure)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_auto_exposure)

func on_value_changed(index: int):
	var env: Environment = world_env.environment
	var attr: CameraAttributesPractical = world_env.camera_attributes
	match index:
		0:
			env.tonemap_exposure = 0.5
			attr.auto_exposure_enabled = false
		1:
			env.tonemap_exposure = 1.0
			attr.auto_exposure_enabled = true
	world_env.environment = env
	world_env.camera_attributes = attr
	
	NoDownforceGlobal.settings_resource.graphics_auto_exposure = index
