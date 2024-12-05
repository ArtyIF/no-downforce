extends Area3D

@export var next: Node3D

func _on_body_entered(body: Node3D) -> void:
	if body is Car and AACCGlobal.current_car == body:
		NoDownforceGlobal.activate_next_checkpoint(self, next)
