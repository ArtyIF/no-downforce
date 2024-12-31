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
	
	if node is ScrollContainer:
		node.gui_input.connect(on_gui_input)
	
	if node is RichTextLabel:
		node.meta_clicked.connect(play_click_sound)
		node.meta_hover_started.connect(play_hover_sound)

func on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index >= MOUSE_BUTTON_WHEEL_UP and event.button_index <= MOUSE_BUTTON_WHEEL_RIGHT:
		NoDownforceGlobal.ui_manager.play_value_change_sound()

func play_click_sound(_arg1 = 0):
	NoDownforceGlobal.ui_manager.play_click_sound()

func play_hover_sound(_arg1 = 0):
	NoDownforceGlobal.ui_manager.play_hover_sound()

func play_value_change_sound(_arg1 = 0):
	NoDownforceGlobal.ui_manager.play_value_change_sound()
