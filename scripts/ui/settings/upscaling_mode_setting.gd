extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_upscaling_mode)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_upscaling_mode)

func on_value_changed(index: int):
	match index:
		0:
			$"/root".get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
		1:
			$"/root".get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR
		2:
			$"/root".get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR2
	
	NoDownforceGlobal.settings_resource.graphics_upscaling_mode = index
