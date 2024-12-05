extends Node
@export var demo: DemoResource

var current_frame: int = 0
@onready var _car: Car = AACCGlobal.current_car

func _physics_process(delta: float) -> void:
	if not _car: return
	if not demo: return
	if current_frame >= len(demo.frames): return

	if current_frame >= 0:
		_car.input_forward = demo.frames[current_frame][0]
		_car.input_backward = demo.frames[current_frame][1]
		_car.input_steer = demo.frames[current_frame][2]
		_car.input_handbrake = demo.frames[current_frame][3]
	else:
		get_node("../RaceTracker").reset()

	current_frame += 1
