extends MeshInstance3D

@export var opengl_material: BaseMaterial3D

func _ready() -> void:
	pass
	#if NoDownforceGlobal.using_opengl:
	#	material_override = opengl_material
