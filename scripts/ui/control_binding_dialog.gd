extends Window

@export var control_to_change: String = ""

var bindings: Array[InputEvent] = []
var waiting_for_press: int = -1

var _user_names_of_bindings: Dictionary[String, String] = {
	"aacc_forward": "Accelerate",
	"aacc_backward": "Brake/Reverse",
	"aacc_steer_left": "Steer Left",
	"aacc_steer_right": "Steer Right",
	"aacc_handbrake": "Handbrake",
	"aaccdemo_reset": "Reset",
}

func _ready() -> void:
	about_to_popup.connect(on_popup)
	close_requested.connect(save_and_close)
	$BG/VBox/CloseButton.pressed.connect(save_and_close)
	$BG/VBox/Scroll/VBox/AddNewBinding.pressed.connect(add_binding)

func refresh_bindings(focus_on_binding: int):
	for child in $BG/VBox/Scroll/VBox/List.get_children():
		if child.name != "BindingTemplate":
			child.queue_free()
	
	bindings = InputMap.action_get_events(control_to_change)
	for i in len(bindings):
		var binding = bindings[i]

		var binding_element: Control = $BG/VBox/Scroll/VBox/List/BindingTemplate.duplicate()
		binding_element.get_node("Binding").text = NoDownforceGlobal.input_event_as_string(binding)
		binding_element.get_node("Binding").pressed.connect(change_binding.bind(i))
		binding_element.get_node("Delete").pressed.connect(delete_binding.bind(i))
		binding_element.visible = true
		$BG/VBox/Scroll/VBox/List.add_child(binding_element)
		
		if i == focus_on_binding:
			binding_element.get_node("Binding").call_deferred("grab_focus")
	
	if waiting_for_press >= len(bindings):
		var binding_element: Control = $BG/VBox/Scroll/VBox/List/BindingTemplate.duplicate()
		binding_element.get_node("Binding").text = "Unassigned"
		binding_element.get_node("Binding").button_pressed = true
		binding_element.visible = true
		$BG/VBox/Scroll/VBox/List.add_child(binding_element)
		binding_element.get_node("Binding").call_deferred("grab_focus")
	
	if len(bindings) == 0:
		$BG/VBox/Scroll/VBox/AddNewBinding.call_deferred("grab_focus")

func on_popup() -> void:
	title = "Control: " + _user_names_of_bindings[control_to_change]
	$BG/VBox/Scroll.set_deferred("scroll_vertical", 0)
	refresh_bindings(0)

func change_binding(i: int):
	if waiting_for_press < 0:
		waiting_for_press = i

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
		InputMap.action_erase_events(control_to_change)
		var bindings_count = len(bindings)
		if waiting_for_press >= len(bindings):
			bindings_count += 1
		for i in bindings_count:
			var old_binding: InputEvent = null
			if i < len(bindings):
				old_binding = bindings[i]
			
			if i == waiting_for_press:
				if event is InputEventJoypadMotion:
					if event.axis_value >= 0.5:
						event.axis_value = 1
					elif event.axis_value <= -0.5:
						event.axis_value = -1
					else:
						success = false
				if success:
					InputMap.action_add_event(control_to_change, event)
				elif old_binding:
					InputMap.action_add_event(control_to_change, old_binding)
			elif old_binding:
				InputMap.action_add_event(control_to_change, old_binding)
		if success:
			refresh_bindings(waiting_for_press)
			waiting_for_press = -1

func save_and_close():
	if waiting_for_press < 0:
		NoDownforceGlobal.settings_resource.save()
		hide()
