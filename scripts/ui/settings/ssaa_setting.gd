extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_ssaa)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_ssaa)

	if NoDownforceGlobal.using_opengl:
		set_item_disabled(1, true)
		get_parent().visible = false

func on_value_changed(index: int):
	if NoDownforceGlobal.using_opengl and index > 0:
		select(0)
		on_value_changed(0)
		return

	match index:
		0:
			$"/root".get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		1:
			$"/root".get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		2:
			$"/root".get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_SMAA
	
	NoDownforceGlobal.settings_resource.graphics_ssaa = index
