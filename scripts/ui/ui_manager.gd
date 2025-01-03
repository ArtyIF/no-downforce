class_name UIManager extends Control
@export var screens: Dictionary[String, Control]
@export var windows: Dictionary[String, Window]

@export_group("Sounds")
@export var click_sound: AudioStream
@export var hover_sound: AudioStream
@export var value_change_sound: AudioStream

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

func show_window(window_name: String):
	windows[window_name].show()

func hide_window(window_name: String):
	windows[window_name].hide()

func popup_window(window_name: String):
	windows[window_name].popup_centered()

func play_click_sound():
	$UISounds.stream = click_sound
	$UISounds.play()

func play_hover_sound():
	if $UISounds.playing and $UISounds.stream == click_sound:
		return
	$UISounds.stream = hover_sound
	$UISounds.play()

func play_value_change_sound():
	$UISounds.stream = value_change_sound
	$UISounds.play()
