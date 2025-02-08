@tool
extends BTAction

@export var position := &"target_position"
@export var speed := 1.0


func _generate_name() -> String:
	return "move (speed:%.1f) %s" % [speed, LimboUtility.decorate_output_var(position)]


func _tick(_delta) -> Status:
	agent.movement_component.speed = speed
	agent.movement_component.move_to(blackboard.get_var(position))
	return SUCCESS
