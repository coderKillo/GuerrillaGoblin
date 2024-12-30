extends State

@export var lose_sight: State
@export var close_to_target: State
@export var run_speed := 1.2


func enter():
	movement_component.speed = run_speed


func exit():
	movement_component.character.modulate = Color.YELLOW


func process_state(_delta):
	movement_component.target_position = target_component.target_position
	movement_component.move_to_target()

	movement_component.character.modulate = Color.RED

	if not target_component.is_target_seen_in_movement_direction(movement_component):
		return lose_sight

	if movement_component.is_close_to_target():
		return close_to_target

	return null
