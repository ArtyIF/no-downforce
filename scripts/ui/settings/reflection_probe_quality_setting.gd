extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_reflection_probe_quality)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_reflection_probe_quality)

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
			$"/root/RaceTrack/ReflectionProbe".visible = false
		1:
			$"/root/RaceTrack/ReflectionProbe".visible = true
			$"/root/RaceTrack/ReflectionProbe".enable_shadows = false
		2:
			$"/root/RaceTrack/ReflectionProbe".visible = true
			$"/root/RaceTrack/ReflectionProbe".enable_shadows = true
	
	NoDownforceGlobal.settings_resource.graphics_reflection_probe_quality = index
