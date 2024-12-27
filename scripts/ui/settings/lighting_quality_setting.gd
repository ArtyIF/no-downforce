extends OptionButton
@export_file("*.lmbake") var baked_light_data: String
@export_file("*.lmbake") var realtime_light_data: String

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_lighting_quality)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_lighting_quality)

func on_value_changed(index: int):
	match index:
		0:
			$"/root/RaceTrack/LightmapGI".light_data = load(baked_light_data)
			$"/root/RaceTrack/Lighting/Sun".light_bake_mode = Light3D.BAKE_STATIC
		1:
			$"/root/RaceTrack/LightmapGI".light_data = load(realtime_light_data)
			$"/root/RaceTrack/Lighting/Sun".light_bake_mode = Light3D.BAKE_DYNAMIC
	
	NoDownforceGlobal.settings_resource.graphics_lighting_quality = index
