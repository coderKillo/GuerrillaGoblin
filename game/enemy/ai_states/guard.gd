extends State

@export var seen_target: State


func process_state(_delta):
	if target_component.is_target_seen_in_movement_direction(movement_component):
		return seen_target

	return null
