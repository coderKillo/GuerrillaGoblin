@tool
extends BTAction

@export var speed := 0.5


func _generate_name() -> String:
	return "patrol on path"


func _enter() -> void:
	assert(agent.path_component.size() >= 2, "path of '%s' is invalid for patroling" % agent.name)

	agent.movement_component.speed = speed
	agent.movement_component.move_to(agent.path_component.next_point())


func _tick(_delta):
	if agent.movement_component.is_close_to_target():
		agent.movement_component.move_to(agent.path_component.next_point())

	agent.direction = agent.movement_component.movement_direction()

	return RUNNING
