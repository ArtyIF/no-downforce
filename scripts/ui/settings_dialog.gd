extends Window

func _ready() -> void:
	close_requested.connect(hide)
	$BG/VBox/CloseButton.pressed.connect(hide)
