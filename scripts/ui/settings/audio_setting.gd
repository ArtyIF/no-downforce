extends Range
@export var bus_name: String = "Master"

func _ready() -> void:
	value_changed.connect(on_value_changed)
	value = NoDownforceGlobal.settings_resource.audio_volumes[bus_name]
	on_value_changed(NoDownforceGlobal.settings_resource.audio_volumes[bus_name])

func on_value_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), max(-80.0, linear_to_db(value)))
	NoDownforceGlobal.settings_resource.audio_volumes[bus_name] = value
