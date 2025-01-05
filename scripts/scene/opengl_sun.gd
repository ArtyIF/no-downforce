extends DirectionalLight3D

func _ready() -> void:
	if NoDownforceGlobal.using_opengl:
		light_energy /= 3.0
