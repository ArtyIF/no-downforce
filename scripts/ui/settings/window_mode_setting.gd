extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_window_mode)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_window_mode)
	
	if OS.has_feature("web"):
		get_parent().visible = false

func on_value_changed(index: int):
	if OS.has_feature("web"):
		return

	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
	NoDownforceGlobal.settings_resource.graphics_window_mode = index
