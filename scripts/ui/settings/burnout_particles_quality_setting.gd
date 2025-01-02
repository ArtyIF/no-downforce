extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_burnout_particles_quality)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_burnout_particles_quality)

	if NoDownforceGlobal.using_opengl:
		set_item_disabled(3, true)
		set_item_disabled(4, true)
		set_item_disabled(5, true)

func on_value_changed(index: int):
	if NoDownforceGlobal.using_opengl and index > 2:
		select(2)
		on_value_changed(2)
		return

	AACCGlobal.current_burnout_particles_quality = index as AACCGlobal.BurnoutParticlesQuality
	NoDownforceGlobal.settings_resource.graphics_burnout_particles_quality = index
