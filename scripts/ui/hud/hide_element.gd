extends Control
@export var element_name: StringName = ""

func _process(_delta: float) -> void:
	visible = NoDownforceGlobal.settings_resource.gameplay_show_hud_elements[element_name]
