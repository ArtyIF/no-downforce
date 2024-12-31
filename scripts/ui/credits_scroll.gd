extends ScrollContainer

var scroll_amount: float = 0.0
var pause_for: float = 0.0

func _ready() -> void:
	gui_input.connect(on_gui_input)
	$VBox/CreditsLabel.meta_clicked.connect(on_meta_clicked)

func _process(delta: float) -> void:
	if is_visible_in_tree():
		if pause_for <= 0.0:
			scroll_amount += delta * 40.0
		else:
			scroll_amount = scroll_vertical
			pause_for -= delta
	else:
		scroll_amount = 0
	scroll_vertical = int(scroll_amount)

func on_gui_input(event: InputEvent):
	if event is not InputEventMouseMotion:
		pause_for = 1.0

func on_meta_clicked(meta):
	OS.shell_open(str(meta))
