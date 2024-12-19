extends OptionButton

func _ready() -> void:
	item_selected.connect(on_value_changed)

func on_value_changed(index: int):
	match index:
		0:
			$"/root/RaceTrack/Camera/ReflectionProbe".visible = false
		1:
			$"/root/RaceTrack/Camera/ReflectionProbe".visible = true
