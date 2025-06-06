extends OptionButton
@export var quality_name: StringName = ""

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.audio_qualities[quality_name])
	on_value_changed(NoDownforceGlobal.settings_resource.audio_qualities[quality_name])

func on_value_changed(index: int):
	AACCGlobal.current_sound_qualities[quality_name] = index as AACCGlobal.SoundQuality
	NoDownforceGlobal.settings_resource.audio_qualities[quality_name] = index as AACCGlobal.SoundQuality
