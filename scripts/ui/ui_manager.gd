class_name UIManager extends Control
@export var screens: Dictionary[String, Control]
@export var overlays: Dictionary[String, Control]
@export var windows: Dictionary[String, Window]

func _ready() -> void:
	NoDownforceGlobal.ui_manager = self

func show_screen(screen_name: String):
	for screen_key in screens.keys():
		if screen_key == screen_name:
			screens[screen_key].visible = true
		else:
			screens[screen_key].visible = false

func hide_screen(screen_name: String):
	screens[screen_name].visible = false

func show_overlay(overlay_name: String):
	overlays[overlay_name].visible = true

func hide_overlay(overlay_name: String):
	overlays[overlay_name].visible = false

func show_window(window_name: String):
	windows[window_name].show()

func hide_window(window_name: String):
	windows[window_name].hide()

func popup_window(window_name: String):
	windows[window_name].popup_centered()
