@tool
extends BTCondition

@export var target_group := "player"
@export var view_angle: float = 30.0


func _generate_name() -> String:
	return "see target of group '%s' (angle:%.2f)" % [target_group, view_angle]


func _tick(_delta) -> Status:
	agent.target_component.target_group = target_group
	if agent.target_component.is_target_seen(agent.direction, view_angle):
		return SUCCESS
	return FAILURE
