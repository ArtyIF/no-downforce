extends Window

@export var binding_to_change: String = ""

var bindings: Array[InputEvent] = []

var _user_names_of_bindings: Dictionary[String, String] = {
	"aacc_forward": "Accelerate",
	"aacc_backward": "Brake/Reverse",
	"aacc_steer_left": "Steer Left",
	"aacc_steer_right": "Steer Right",
	"aacc_handbrake": "Handbrake",
	"aaccdemo_reset": "Reset",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	about_to_popup.connect(on_popup)
	close_requested.connect(save_and_close)
	$BG/VBox/CloseButton.pressed.connect(save_and_close)

func on_popup() -> void:
	title = "Control: " + _user_names_of_bindings[binding_to_change]
	
	for child in $BG/VBox/Scroll/VBox/List.get_children():
		if child.name != "BindingTemplate":
			child.queue_free()
	
	bindings = InputMap.action_get_events(binding_to_change)
	for binding in bindings:
		var binding_element: Control = $BG/VBox/Scroll/VBox/List/BindingTemplate.duplicate()
		binding_element.get_node("Binding").text = NoDownforceGlobal.input_event_as_string(binding)
		binding_element.visible = true
		$BG/VBox/Scroll/VBox/List.add_child(binding_element)

func save_and_close():
	NoDownforceGlobal.settings_resource.save()
	hide()
