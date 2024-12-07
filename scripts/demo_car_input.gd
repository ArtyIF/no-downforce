extends Node
@export var demo: DemoResource
@export var start_from_frame: int = 0
@export var apply_transform: bool = true

var current_frame: int = 0
@onready var _car: Car = AACCGlobal.current_car

func _ready() -> void:
	NoDownforceGlobal.demo_car_input = self

func load_demo() -> void:
	current_frame = -1
	if not demo:
		$"../UI/DemoScreen".visible = false
		NoDownforceGlobal.playing_demo = false
		return
	if demo.version != ProjectSettings.get_setting("application/config/version"):
		$"../UI/DemoScreen/OutdatedDemoWarning".visible = true
		$"../UI/DemoScreen/OutdatedDemoWarning/VBox/Version".text = demo.version if demo.version != "" else "0.1"
	else:
		$"../UI/DemoScreen/OutdatedDemoWarning".visible = false
	$"../UI/DemoScreen".visible = true
	NoDownforceGlobal.playing_demo = true

func _physics_process(_delta: float) -> void:
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
		if len(demo.frames[current_frame]) > 5:
			_car.linear_velocity = demo.frames[current_frame][5]
			_car.angular_velocity = demo.frames[current_frame][6]

	current_frame += 1
