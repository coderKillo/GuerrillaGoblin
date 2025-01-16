extends BTAction

@export var position := &"target_position"


func _tick(_delta) -> Status:
	blackboard.set_var(position, agent.target_component.target_position)
	return SUCCESS
