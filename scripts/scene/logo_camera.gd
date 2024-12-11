extends Camera3D

func _ready() -> void:
	update_subviewport()
	$"/root".get_viewport().size_changed.connect(update_subviewport)

func _process(_delta: float) -> void:
	global_transform = $"/root".get_viewport().get_camera_3d().get_global_transform_interpolated()
	projection = $"/root".get_viewport().get_camera_3d().projection
	fov = $"/root".get_viewport().get_camera_3d().fov
	size = $"/root".get_viewport().get_camera_3d().size
	frustum_offset = $"/root".get_viewport().get_camera_3d().frustum_offset

func update_subviewport() -> void:
	$"..".size = DisplayServer.window_get_size()
