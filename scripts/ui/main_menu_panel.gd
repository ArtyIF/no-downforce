extends Control

func _ready() -> void:
	$BG/HBox/PlayButton.grab_focus()

func _process(delta: float) -> void:
	NoDownforceGlobal.showing_main_menu = visible
