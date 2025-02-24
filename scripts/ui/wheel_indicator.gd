extends Control
@export var node_path: String

func _process(delta: float) -> void:
	modulate = Color.WHITE if AACCGlobal.current_car.get_node(node_path).is_colliding else Color.TRANSPARENT
