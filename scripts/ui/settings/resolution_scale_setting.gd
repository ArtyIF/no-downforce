extends Range

func _ready() -> void:
	value_changed.connect(on_value_changed)
	value = NoDownforceGlobal.settings_resource.graphics_resolution_scale
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_resolution_scale)

func on_value_changed(new_value: float):
	$"/root".get_viewport().scaling_3d_scale = value
	
	NoDownforceGlobal.settings_resource.graphics_resolution_scale = new_value
