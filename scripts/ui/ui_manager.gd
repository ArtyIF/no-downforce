class_name UIManager extends Control
@export var screens: Array[Control]

func _ready() -> void:
	NoDownforceGlobal.ui_manager = self

func show_screen(screen_name: String, hide_other_screens: bool = true):
	for screen in screens:
		if screen.name == screen_name:
			screen.visible = true
		elif hide_other_screens:
			screen.visible = false

func hide_screen(screen_name: String):
	for screen in screens:
		if screen.name == screen_name:
			screen.visible = false
			return

func get_screen(screen_name: String) -> Control:
	if screen_name == ".":
		return self
	for screen in screens:
		if screen.name == screen_name:
			return screen
	return null
