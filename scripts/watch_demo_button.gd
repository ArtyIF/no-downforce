extends Button

func _ready() -> void:
	pressed.connect(on_press)

func on_press() -> void:
	$"../../DemoFileDialog".show()
