@tool
extends BTAction

@export var position := &"target_position"


func _generate_name() -> String:
	return "Look at %s" % LimboUtility.decorate_output_var(position)


func _enter():
	agent.movement_component.speed = 0.0


func _tick(_delta) -> Status:
	agent.direction = agent.global_position.direction_to(blackboard.get_var(position))

	return RUNNING
