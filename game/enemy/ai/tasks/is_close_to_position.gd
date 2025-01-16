extends BTCondition
@export var position := &"target_position"
@export var tolerance := 50.0


func _tick(_delta) -> Status:
	if agent.global_position.distance_to(blackboard.get_var(position)) < tolerance:
		return SUCCESS
	return FAILURE
