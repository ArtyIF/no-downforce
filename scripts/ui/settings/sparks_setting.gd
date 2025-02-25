extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_sparks)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_sparks)

func on_value_changed(index: int):
	match index:
		0:
			AACCGlobal.current_emit_sparks = false
		1:
			AACCGlobal.current_emit_sparks = true
	
	NoDownforceGlobal.settings_resource.graphics_sparks = index
