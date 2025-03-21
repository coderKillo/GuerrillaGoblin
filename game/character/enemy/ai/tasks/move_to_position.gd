@tool
extends BTAction

@export var position := &"target_position"
@export var speed := 1.0
@export var face_destination := true


func _generate_name() -> String:
	return (
		"move to %s (speed:%.1f, facing:%s)"
		% [LimboUtility.decorate_output_var(position), speed, face_destination]
	)


func _tick(_delta) -> Status:
	var pos = blackboard.get_var(position)

	agent.movement_component.speed = speed
	agent.movement_component.move_to(pos)

	if face_destination:
		agent.direction = agent.global_position.direction_to(pos)

	if agent.movement_component.is_close_to_target():
		return SUCCESS

	return RUNNING
