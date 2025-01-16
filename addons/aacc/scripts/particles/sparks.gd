extends GPUParticles3D

var emitted: bool = false

func _ready() -> void:
	emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()
