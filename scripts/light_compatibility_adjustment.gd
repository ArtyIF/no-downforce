@tool
extends DirectionalLight3D

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		light_angular_distance = 0.0
