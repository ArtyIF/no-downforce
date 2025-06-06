extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)
	select(NoDownforceGlobal.settings_resource.graphics_vsync)
	on_value_changed(NoDownforceGlobal.settings_resource.graphics_vsync)
	
	if OS.has_feature("web"):
		get_parent().visible = false

func on_value_changed(index: int):
	if OS.has_feature("web"):
		return

	match index:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		2:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
		3:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_MAILBOX)
	
	NoDownforceGlobal.settings_resource.graphics_vsync = index
