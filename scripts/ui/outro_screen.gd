extends Control

func _process(_delta: float) -> void:
	if visible:
		$BG/VBox/TargetTimeLabel.visible = NoDownforceGlobal.demo_car_input.custom_car != null
		$BG/VBox/TargetTime.visible = NoDownforceGlobal.demo_car_input.custom_car != null
		$BG/VBox/DifferenceLabel.visible = NoDownforceGlobal.demo_car_input.custom_car != null
		$BG/VBox/Difference.visible = NoDownforceGlobal.demo_car_input.custom_car != null
		if NoDownforceGlobal.demo_car_input.custom_car:
			$BG/VBox/TargetTime.text = NoDownforceGlobal.float_to_time(NoDownforceGlobal.demo_car_input.demo.length - NoDownforceGlobal.demo_car_input.demo.start_time)
			var difference: float = NoDownforceGlobal.time_passed - NoDownforceGlobal.demo_car_input.demo.length - NoDownforceGlobal.demo_car_input.demo.start_time
			if difference > 0:
				$BG/VBox/Difference.text = "+" + NoDownforceGlobal.float_to_time(difference)
			elif difference < 0:
				$BG/VBox/Difference.text = "-" + NoDownforceGlobal.float_to_time(abs(difference))
			else:
				$BG/VBox/Difference.text = NoDownforceGlobal.float_to_time(difference)
