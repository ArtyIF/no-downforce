extends Label

func _process(_delta: float) -> void:
	if NoDownforceGlobal.settings_resource.gameplay_speed_unit == 1:
		text = "mph"
	else:
		text = "km/h"
