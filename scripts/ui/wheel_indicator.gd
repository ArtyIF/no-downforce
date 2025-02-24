extends ColorRect
@export var node_path: String

func _process(delta: float) -> void:
	visible = AACCGlobal.current_car.get_node(node_path).is_colliding
