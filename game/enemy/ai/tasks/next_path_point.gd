extends BTAction

@export var position := &"target_position"


func _tick(_delta) -> Status:
	blackboard.set_var(position, agent.path_component.next_point())
	return SUCCESS
