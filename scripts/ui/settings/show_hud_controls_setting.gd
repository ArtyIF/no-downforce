extends OptionButton
@export var element_name: StringName = ""

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.gameplay_show_hud_elements[element_name])
	on_value_changed(NoDownforceGlobal.settings_resource.gameplay_show_hud_elements[element_name])

func on_value_changed(index: int):
	NoDownforceGlobal.settings_resource.gameplay_show_hud_elements[element_name] = bool(index)
