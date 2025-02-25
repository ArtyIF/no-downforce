extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.gameplay_speed_unit)
	on_value_changed(NoDownforceGlobal.settings_resource.gameplay_speed_unit)

func on_value_changed(index: int):
	NoDownforceGlobal.settings_resource.gameplay_speed_unit = index
