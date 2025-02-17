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
			$"/root/RaceTrack/Lighting/DefaultReflectionProbeAbove".reflection_mask = 3
			$"/root/RaceTrack/Lighting/DefaultReflectionProbeBelow".reflection_mask = 3
			$"/root/RaceTrack/Lighting/StartReflectionProbe".reflection_mask = 3

			$"/root/RaceTrack/DynamicReflectionProbe".visible = false
		1:
			$"/root/RaceTrack/Lighting/DefaultReflectionProbeAbove".reflection_mask = 1
			$"/root/RaceTrack/Lighting/DefaultReflectionProbeBelow".reflection_mask = 1
			$"/root/RaceTrack/Lighting/StartReflectionProbe".reflection_mask = 1

			$"/root/RaceTrack/DynamicReflectionProbe".visible = true
			$"/root/RaceTrack/DynamicReflectionProbe".enable_shadows = false
		2:
			$"/root/RaceTrack/Lighting/DefaultReflectionProbeAbove".reflection_mask = 1
			$"/root/RaceTrack/Lighting/DefaultReflectionProbeBelow".reflection_mask = 1
			$"/root/RaceTrack/Lighting/StartReflectionProbe".reflection_mask = 1

			$"/root/RaceTrack/DynamicReflectionProbe".visible = true
			$"/root/RaceTrack/DynamicReflectionProbe".enable_shadows = true
	
	NoDownforceGlobal.settings_resource.graphics_reflection_probe_quality = index
