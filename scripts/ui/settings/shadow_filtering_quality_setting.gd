extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_shadow_filtering_quality)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_shadow_filtering_quality)
	
	if NoDownforceGlobal.using_opengl:
		set_item_disabled(1, true)
		set_item_disabled(3, true)
		set_item_disabled(5, true)

func on_value_changed(index: int):
	if NoDownforceGlobal.using_opengl:
		if index == 1:
			select(0)
			on_value_changed(0)
			return
		if index == 3:
			select(2)
			on_value_changed(2)
			return
		if index == 5:
			select(4)
			on_value_changed(4)
			return

	match index:
		0:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
		1:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
		2:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		3:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
		4:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
		5:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)

	NoDownforceGlobal.settings_resource.graphics_shadow_filtering_quality = index
