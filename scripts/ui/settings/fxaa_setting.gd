extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_fxaa)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_fxaa)

func on_value_changed(index: int):
	match index:
		0:
			$"/root".get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		1:
			$"/root".get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
	
	NoDownforceGlobal.settings_resource.graphics_fxaa = index
