extends Range

func _ready() -> void:
	value_changed.connect(on_value_changed)

func on_value_changed(value: float):
	$"/root".get_viewport().scaling_3d_scale = value
