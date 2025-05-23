extends Area3D

@export var next: Node3D

func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D) -> void:
	if not NoDownforceGlobal.playing_demo and body is Car and AACCGlobal.current_car == body:
		NoDownforceGlobal.activate_next_checkpoint(self, next)
