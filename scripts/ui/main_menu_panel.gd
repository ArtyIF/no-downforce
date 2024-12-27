extends Control

func _ready() -> void:
	$BG/HBox/RaceButton.call_deferred("grab_focus")

func _process(_delta: float) -> void:
	NoDownforceGlobal.showing_main_menu = visible
