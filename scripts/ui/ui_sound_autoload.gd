extends Node

func _enter_tree() -> void:
	get_tree().node_added.connect(connect_ui_sounds)

func connect_ui_sounds(node: Node):
	if node is BaseButton:
		node.pressed.connect(play_click_sound)

		node.focus_entered.connect(play_hover_sound)
		node.mouse_entered.connect(play_hover_sound)

	if node is TabBar:
		node.tab_clicked.connect(play_click_sound)

		node.tab_hovered.connect(play_hover_sound)
		node.tab_selected.connect(play_hover_sound)
		node.focus_entered.connect(play_hover_sound)

	if node is PopupMenu:
		node.id_pressed.connect(play_click_sound)

		node.id_focused.connect(play_hover_sound)

	if node is Slider:
		node.value_changed.connect(play_value_change_sound)

		node.focus_entered.connect(play_hover_sound)
		node.mouse_entered.connect(play_hover_sound)

func play_click_sound(_arg1 = 0):
	NoDownforceGlobal.ui_manager.play_click_sound()

func play_hover_sound(_arg1 = 0):
	NoDownforceGlobal.ui_manager.play_hover_sound()

func play_value_change_sound(_arg1 = 0):
	NoDownforceGlobal.ui_manager.play_value_change_sound()
