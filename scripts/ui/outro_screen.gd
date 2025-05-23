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
			var difference: float = NoDownforceGlobal.time_passed - (NoDownforceGlobal.demo_car_input.demo.length - NoDownforceGlobal.demo_car_input.demo.start_time) - (2.0 / Engine.physics_ticks_per_second)
			if difference > 0:
				$BG/VBox/RunFinished.text = "Better luck next time!"
				$BG/VBox/Difference.text = "+" + NoDownforceGlobal.float_to_time(difference)
			elif difference < 0:
				$BG/VBox/RunFinished.text = "You beat the ghost!"
				$BG/VBox/Difference.text = "-" + NoDownforceGlobal.float_to_time(abs(difference))
			else:
				$BG/VBox/RunFinished.text = "It's a tie!"
				$BG/VBox/Difference.text = NoDownforceGlobal.float_to_time(difference)
		else:
			$BG/VBox/RunFinished.text = "Run finished!"
		$BG/VBox/SaveButton.call_deferred("grab_focus")

func on_save() -> void:
	NoDownforceGlobal.race_tracker.demo.name = $BG/VBox/DemoName.text
	NoDownforceGlobal.race_tracker.demo.save()
	NoDownforceGlobal.demo_car_input.demo = null
	NoDownforceGlobal.race_tracker.reset(true)
	NoDownforceGlobal.ui_manager.show_screen("MainMenu")
	NoDownforceGlobal.ui_manager.screens["MainMenu"].get_node("BG/HBox/RaceButton").call_deferred("grab_focus")
