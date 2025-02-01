extends OptionButton
@onready var world_env: WorldEnvironment = $"/root/RaceTrack/Lighting/WorldEnvironment"

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_auto_exposure)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_auto_exposure)

	if NoDownforceGlobal.using_opengl:
		set_item_disabled(1, true)
		get_parent().visible = false

func on_value_changed(index: int):
	if NoDownforceGlobal.using_opengl and index > 0:
		select(0)
		on_value_changed(0)
		return
	
	var env: Environment = world_env.environment
	var attr: CameraAttributesPractical = world_env.camera_attributes
	match index:
		0:
			env.tonemap_exposure = 0.17
			attr.auto_exposure_enabled = false
		1:
			env.tonemap_exposure = 1.0
			attr.auto_exposure_enabled = true
	world_env.environment = env
	world_env.camera_attributes = attr
	
	NoDownforceGlobal.settings_resource.graphics_auto_exposure = index
