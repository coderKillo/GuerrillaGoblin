@tool
extends BTAction

@export var target_group := ""


func _generate_name() -> String:
	return "find closest target of '%s'" % [target_group]


func _tick(_delta) -> Status:
	var targets = agent.target_component.get_targets_by_distance(target_group)
	if not targets:
		return FAILURE

	agent.target_component.target = targets[0]
	agent.target_component.last_target_position = targets[0].global_position

	return SUCCESS
