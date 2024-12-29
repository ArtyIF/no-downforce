extends Label

@export var at_checkpoint: bool = false

func _process(_delta: float) -> void:
	if at_checkpoint and NoDownforceGlobal.checkpoints_passed + 1 == NoDownforceGlobal.total_checkpoints:
		text = "FINISH"
		$"../CheckpointLabel".visible = false
	else:
		text = "%d/%d" % [NoDownforceGlobal.checkpoints_passed + (1 if at_checkpoint else 0), NoDownforceGlobal.total_checkpoints]
		$"../CheckpointLabel".visible = true
