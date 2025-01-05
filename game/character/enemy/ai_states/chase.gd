extends State

@export var lose_sight: State
@export var close_to_target: State
@export var run_speed := 1.2


func enter():
	movement_component.speed = run_speed


func exit():
	movement_component.character.modulate = Color.YELLOW


func process_state(_delta):
	movement_component.move_to(target_component.last_target_position)

	movement_component.character.modulate = Color.RED

	if not target_component.is_target_seen(movement_component.movement_direction()):
		return lose_sight

	if movement_component.is_close_to_target():
		return close_to_target

	return null
