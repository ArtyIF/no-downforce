extends Control

func _ready() -> void:
	visibility_changed.connect(on_show)
	$BG/VBox/SaveButton.pressed.connect(on_save)

func on_show() -> void:
	if visible:
		$BG/VBox/TargetTimeLabel.visible = NoDownforceGlobal.demo_car_input.custom_car != null
		$BG/VBox/TargetTime.visible = NoDownforceGlobal.demo_car_input.custom_car != null
		$BG/VBox/DifferenceLabel.visible = NoDownforceGlobal.demo_car_input.custom_car != null
		$BG/VBox/Difference.visible = NoDownforceGlobal.demo_car_input.custom_car != null
		if NoDownforceGlobal.demo_car_input.custom_car:
			$BG/VBox/TargetTime.text = NoDownforceGlobal.float_to_time(NoDownforceGlobal.demo_car_input.demo.length - NoDownforceGlobal.demo_car_input.demo.start_time)
			var difference: float = NoDownforceGlobal.time_passed - (NoDownforceGlobal.demo_car_input.demo.length - NoDownforceGlobal.demo_car_input.demo.start_time)
			if difference > 0:
				$BG/VBox/Difference.text = "+" + NoDownforceGlobal.float_to_time(difference)
			elif difference < 0:
				$BG/VBox/Difference.text = "-" + NoDownforceGlobal.float_to_time(abs(difference))
			else:
				$BG/VBox/Difference.text = NoDownforceGlobal.float_to_time(difference)
		$BG/VBox/SaveButton.call_deferred("grab_focus")

func _process(delta: float) -> void:
	pass

func on_save() -> void:
	NoDownforceGlobal.race_tracker.demo.name = $BG/VBox/DemoName.text
	NoDownforceGlobal.race_tracker.demo.save()
	NoDownforceGlobal.race_tracker.reset(true)
	NoDownforceGlobal.ui_manager.show_screen("MainMenu")
