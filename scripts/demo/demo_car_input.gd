class_name DemoCarInput extends Node
@export var demo: DemoResource
@export var apply_transform: bool = true
@export var apply_velocity: bool = true

var current_frame: int = 0
@onready var _car: Car = AACCGlobal.current_car

func _ready() -> void:
	NoDownforceGlobal.demo_car_input = self

func load_demo() -> void:
	current_frame = -1
	_car.reset()
	if not demo:
		NoDownforceGlobal.ui_manager.hide_overlay("DemoOverlay")
		NoDownforceGlobal.playing_demo = false
		return
	if demo.version == "" or demo.version == "0.2" or demo.version == "0.3":
		NoDownforceGlobal.ui_manager.windows["ErrorDialog"].dialog_text = "The version of this demo is too old to be played properly."
		NoDownforceGlobal.ui_manager.call_deferred("popup_window", "ErrorDialog")
		demo = null
		return
	if demo.version != ProjectSettings.get_setting("application/config/version"):
		NoDownforceGlobal.ui_manager.overlays["DemoOverlay"].get_node("OutdatedDemoWarning").visible = true
		NoDownforceGlobal.ui_manager.overlays["DemoOverlay"].get_node("OutdatedDemoWarning/VBox/Version").text = demo.version if demo.version != "" else "0.1"
	else:
		NoDownforceGlobal.ui_manager.overlays["DemoOverlay"].get_node("OutdatedDemoWarning").visible = false
	NoDownforceGlobal.ui_manager.show_screen("IntroScreen")
	NoDownforceGlobal.ui_manager.show_overlay("DemoOverlay")
	NoDownforceGlobal.playing_demo = true

func _physics_process(_delta: float) -> void:
	if not _car: return
	if not demo: return
	if current_frame >= len(demo.frames): return

	if current_frame >= 0:
		_car.input_forward = demo.frames[current_frame][0]
		_car.input_backward = demo.frames[current_frame][1]
		_car.input_steer = demo.frames[current_frame][2]
		_car.input_handbrake = demo.frames[current_frame][3]
		if len(demo.frames[current_frame]) > 4 and apply_transform:
			_car.global_transform = demo.frames[current_frame][4]
		if len(demo.frames[current_frame]) > 5 and apply_velocity:
			_car.linear_velocity = demo.frames[current_frame][5]
			_car.angular_velocity = demo.frames[current_frame][6]

	current_frame += 1
