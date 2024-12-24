extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_msaa)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_msaa)

func on_value_changed(index: int):
	match index:
		0:
			$"/root".get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		1:
			$"/root".get_viewport().msaa_3d = Viewport.MSAA_2X
		2:
			$"/root".get_viewport().msaa_3d = Viewport.MSAA_4X
		3:
			$"/root".get_viewport().msaa_3d = Viewport.MSAA_8X
	
	NoDownforceGlobal.settings_resource.graphics_msaa = index
