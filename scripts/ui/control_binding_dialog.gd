extends Window

@export var control_to_change: String = ""

var bindings: Array[InputEvent] = []
var waiting_for_press: int = -1

func _ready() -> void:
	about_to_popup.connect(on_popup)
	close_requested.connect(save_and_close)
	$BG/VBox/CloseButton.pressed.connect(save_and_close)
	$BG/VBox/Scroll/List/AddNewBinding.pressed.connect(add_binding)
	$BG/VBox/Deadzone/Value.value_changed.connect(change_deadzone)

func refresh_bindings(focus_on_binding: int):
	for child in $BG/VBox/Scroll/List/Bindings.get_children():
		if child.name != "BindingTemplate":
			child.queue_free()
	
	bindings = InputMap.action_get_events(control_to_change)
	for i in len(bindings):
		var binding = bindings[i]

		var binding_element: Control = $BG/VBox/Scroll/List/Bindings/BindingTemplate.duplicate()
		binding_element.get_node("Binding").text = NoDownforceGlobal.input_event_as_string(binding)
		binding_element.get_node("Binding").pressed.connect(change_binding.bind(i, binding_element.get_node("Binding")))
		binding_element.get_node("Delete").pressed.connect(delete_binding.bind(i))
		binding_element.visible = true
		$BG/VBox/Scroll/List/Bindings.add_child(binding_element)
		
		if i == focus_on_binding:
			binding_element.get_node("Binding").call_deferred("grab_focus")
	
	if waiting_for_press >= len(bindings):
		var binding_element: Control = $BG/VBox/Scroll/List/Bindings/BindingTemplate.duplicate()
		binding_element.get_node("Binding").text = "Waiting for input..."
		binding_element.get_node("Binding").button_pressed = true
		binding_element.visible = true
		$BG/VBox/Scroll/List/Bindings.add_child(binding_element)
		binding_element.get_node("Binding").call_deferred("grab_focus")
	
	if len(bindings) == 0:
		$BG/VBox/Scroll/List/AddNewBinding.call_deferred("grab_focus")

func on_popup() -> void:
	title = "Control: " + SettingsResource.rebindable_controls[control_to_change]
	$BG/VBox/Scroll.set_deferred("scroll_vertical", 0)
	$BG/VBox/Deadzone/Value.value = InputMap.action_get_deadzone(control_to_change)
	refresh_bindings(0)

func change_binding(i: int, button: BaseButton):
	if waiting_for_press < 0:
		waiting_for_press = i
		button.text = "Waiting for input..."
	else:
		button.button_pressed = false

func delete_binding(i: int):
	if waiting_for_press < 0:
		InputMap.action_erase_event(control_to_change, bindings[i])
		refresh_bindings(clamp(i, 0, len(bindings) - 2))

func add_binding():
	waiting_for_press = len(bindings)
	refresh_bindings(len(bindings))

func _input(event: InputEvent) -> void:
	if waiting_for_press >= 0 and (event is InputEventKey or event is InputEventJoypadMotion or event is InputEventJoypadButton):
		var success: bool = true
		var bindings_count = len(bindings)
		if waiting_for_press >= len(bindings):
			bindings_count += 1
		for i in bindings_count:
			if i == waiting_for_press:
				if event is InputEventJoypadMotion:
					if event.axis_value >= 0.5:
						event.axis_value = 1
					elif event.axis_value <= -0.5:
						event.axis_value = -1
					else:
						success = false

				if event is InputEventJoypadButton:
					if not event.pressed:
						success = false
				if event is InputEventKey:
					# fixes web bindings being wrong, hopefully
					event.keycode = 0
					event.key_label = 0
					if not event.pressed or event.physical_keycode == 0:
						success = false
				if Input.is_action_pressed(control_to_change):
					success = false

				if success:
					if len(bindings) <= i:
						bindings.append(event)
					else:
						bindings[i] = event

		if success:
			InputMap.action_erase_events(control_to_change)
			for binding in bindings:
				InputMap.action_add_event(control_to_change, binding)
			refresh_bindings(waiting_for_press)
			waiting_for_press = -1

func change_deadzone(value: float):
	InputMap.action_set_deadzone(control_to_change, value)

func save_and_close():
	if waiting_for_press < 0:
		NoDownforceGlobal.settings_resource.save()
		hide()
