@tool
extends BTCondition


func _generate_name() -> String:
	return "has heard sound"


func _tick(_delta) -> Status:
	if agent.listener_component.has_sound_heard():
		return SUCCESS
	return FAILURE
