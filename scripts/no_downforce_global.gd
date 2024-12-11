extends Node

var checkpoints_passed: int = 0
var total_checkpoints: int = 5
var time_passed: float = 0.0
var timer_going: bool = false
var demo_car_input: DemoCarInput
var playing_demo: bool = false
var ui_manager: UIManager
var camera: NoDownforceCamera

func activate_next_checkpoint(current: Node3D, next: Node3D):
	checkpoints_passed += 1

	current.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	current.visible = false

	if checkpoints_passed < total_checkpoints:
		next.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
		next.visible = true
	else:
		timer_going = false

func reset_race(checkpoints_list: Array[Node3D]):
	for checkpoint in checkpoints_list:
		checkpoint.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		checkpoint.visible = false

	checkpoints_list[0].set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	checkpoints_list[0].visible = true

	checkpoints_passed = 0
	time_passed = 0.0
	timer_going = false

func update_timer(delta: float):
	if timer_going:
		time_passed += delta
