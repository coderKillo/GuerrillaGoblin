extends State

@export var arrive_at_position: State
@export var seen_target: State

@export var walk_speed := 0.5
@export var run_speed := 1.2


func enter():
	movement_component.speed = walk_speed
	movement_component.move_to(target_component.last_target_position)


func process_state(_delta):
	movement_component.character.modulate = Color.YELLOW

	if movement_component.is_close_to_target():
		return arrive_at_position

	if target_component.is_target_seen(movement_component.movement_direction()):
		return seen_target

	return null
