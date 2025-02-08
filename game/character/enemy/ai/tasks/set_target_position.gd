@tool
extends BTAction

@export var position := &"target_position"


func _generate_name() -> String:
	return "set last_target_position to %s" % LimboUtility.decorate_output_var(position)


func _tick(_delta) -> Status:
	blackboard.set_var(position, agent.target_component.last_target_position)
	return SUCCESS
