extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_upscaling_mode)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_upscaling_mode)
	
	if NoDownforceGlobal.using_opengl:
		set_item_disabled(1, true)
		set_item_disabled(2, true)
		get_parent().visible = false

func on_value_changed(index: int):
	if NoDownforceGlobal.using_opengl and index > 0:
		select(0)
		on_value_changed(0)
		return

	match index:
		0:
			$"/root".get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
		1:
			$"/root".get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR
		2:
			$"/root".get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR2
	
	NoDownforceGlobal.settings_resource.graphics_upscaling_mode = index
