@tool
extends BTAction

@export var speed := 0.5

var _guard_position: Vector2
var _guard_direction: Vector2


func _generate_name() -> String:
	return "guard position"


func _enter() -> void:
	assert(
		agent.path_component.size() == 2,
		"invalid path for '%s': need EXACTLY 2 points" % agent.name
	)

	_guard_position = agent.path_component.next_point()
	_guard_direction = _guard_position.direction_to(agent.path_component.next_point())

	agent.movement_component.speed = speed


func _tick(_delta):
	agent.movement_component.move_to(_guard_position)
	agent.direction = agent.movement_component.movement_direction()

	if agent.movement_component.is_close_to_target():
		agent.direction = _guard_direction
		return SUCCESS

	return RUNNING
