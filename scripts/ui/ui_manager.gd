class_name UIManager extends Control
@export var screens: Dictionary[String, Control]
@export var overlays: Dictionary[String, Control]
@export var windows: Dictionary[String, Window]

func _ready() -> void:
	NoDownforceGlobal.ui_manager = self

func show_screen(screen_name: String):
	for screen in screens.values():
		screen.visible = false
	screens[screen_name].visible = true

func hide_screen(screen_name: String):
	screens[screen_name].visible = false

func show_overlay(overlay_name: String):
	overlays[overlay_name].visible = true

func hide_overlay(overlay_name: String):
	overlays[overlay_name].visible = false

func show_window(window_name: String):
	windows[window_name].visible = true

func hide_window(window_name: String):
	windows[window_name].visible = false

func popup_window(window_name: String):
	windows[window_name].popup_centered()
