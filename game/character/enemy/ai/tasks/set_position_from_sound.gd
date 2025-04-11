@tool
extends BTAction

@export var position := &"target_position"


func _generate_name() -> String:
	return "set sound position %s" % LimboUtility.decorate_output_var(position)


func _tick(_delta) -> Status:
	if agent.listener_component.sound_string.contains("GOTO:"):
		var coord = agent.listener_component.sound_string.split(":")[1]
		blackboard.set_var(position, str_to_var("Vector2" + coord))
	else:
		blackboard.set_var(position, agent.listener_component.sound_position)
	return SUCCESS
