extends Range

func _ready() -> void:
	value_changed.connect(on_value_changed)
	value = NoDownforceGlobal.settings_resource.accessibility_game_speed
	on_value_changed(NoDownforceGlobal.settings_resource.accessibility_game_speed)

func on_value_changed(new_value: float):
	if not NoDownforceGlobal.playing_demo and NoDownforceGlobal.timer_going:
		Engine.time_scale = value
		Engine.physics_ticks_per_second = 12 * floori(value * 20)
	
	NoDownforceGlobal.settings_resource.accessibility_game_speed = new_value
