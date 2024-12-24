extends OptionButton
@export var baked_light_data: LightmapGIData
@export var realtime_light_data: LightmapGIData

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_lighting_quality)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_lighting_quality)

func on_value_changed(index: int):
	match index:
		0:
			$"/root/RaceTrack/LightmapGI".light_data = baked_light_data
			$"/root/RaceTrack/Lighting/Sun".light_bake_mode = Light3D.BAKE_STATIC
		1:
			$"/root/RaceTrack/LightmapGI".light_data = realtime_light_data
			$"/root/RaceTrack/Lighting/Sun".light_bake_mode = Light3D.BAKE_DYNAMIC
	
	NoDownforceGlobal.settings_resource.graphics_lighting_quality = index
