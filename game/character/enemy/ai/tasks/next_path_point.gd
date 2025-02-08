extends BTAction

@export var position := &"target_position"


func _tick(_delta) -> Status:
	var point = agent.path_component.next_point()
	blackboard.set_var(position, point)
	return SUCCESS
