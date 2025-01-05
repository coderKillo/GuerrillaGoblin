extends State

@export var seen_target: State


func process_state(_delta):
	if target_component.is_target_seen(movement_component.movement_direction()):
		return seen_target

	return null
