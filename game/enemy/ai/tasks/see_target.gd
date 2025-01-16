extends BTCondition
@export var target_group := &"player"


func _tick(_delta) -> Status:
	agent.target_component.target_group = target_group
	if agent.target_component.is_target_seen(agent.direction):
		return SUCCESS
	return FAILURE
