extends Node
@export var demo: DemoResource
@export var start_from_frame: int = 0
@export var apply_transform: bool = true

var current_frame: int = 0
@onready var _car: Car = AACCGlobal.current_car

func _ready() -> void:
	if not demo: return
	if demo.version != ProjectSettings.get_setting("application/config/version"):
		get_node("../OutdatedDemoVersionWarning").visible = true
		get_node("../OutdatedDemoVersionWarning/BG/VBox/Version").text = demo.version if demo.version != "" else "0.1"

func _physics_process(delta: float) -> void:
	if not _car: return
	if not demo: return
	if current_frame >= len(demo.frames): return

	if current_frame >= start_from_frame:
		_car.input_forward = demo.frames[current_frame][0]
		_car.input_backward = demo.frames[current_frame][1]
		_car.input_steer = demo.frames[current_frame][2]
		_car.input_handbrake = demo.frames[current_frame][3]
		if len(demo.frames[current_frame]) > 4 and apply_transform:
			_car.global_transform = demo.frames[current_frame][4]
	else:
		get_node("../RaceTracker").reset()

	current_frame += 1
