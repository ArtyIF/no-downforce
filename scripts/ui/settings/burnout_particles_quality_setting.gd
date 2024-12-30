extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_burnout_particles_quality)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_burnout_particles_quality)

func on_value_changed(index: int):
	AACCGlobal.current_burnout_particles_quality = index as AACCGlobal.BurnoutParticlesQuality
	NoDownforceGlobal.settings_resource.graphics_burnout_particles_quality = index
