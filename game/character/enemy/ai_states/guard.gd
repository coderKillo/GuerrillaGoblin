extends State

@export var seen_target: State
@export var view_direction: Vector2


func process_state(_delta):
	if target_component.is_target_seen(view_direction):
		return seen_target

	return null
