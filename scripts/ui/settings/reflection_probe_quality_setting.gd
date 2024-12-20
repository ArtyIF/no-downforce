extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_reflection_probe_quality)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_reflection_probe_quality)

func on_value_changed(index: int):
	match index:
		0:
			$"/root/RaceTrack/Camera/ReflectionProbe".visible = false
		1:
			$"/root/RaceTrack/Camera/ReflectionProbe".visible = true
			$"/root/RaceTrack/Camera/ReflectionProbe".enable_shadows = false
		2:
			$"/root/RaceTrack/Camera/ReflectionProbe".visible = true
			$"/root/RaceTrack/Camera/ReflectionProbe".enable_shadows = true
	
	NoDownforceGlobal.settings_resource.graphics_reflection_probe_quality = index
