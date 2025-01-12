extends State

@export var max_distance := 2000


func enter():
	movement_component.speed = Settings.run_speed
	movement_component.move_to(
		-global_position.direction_to(target_component.last_target_position) * max_distance
	)
	movement_component.character.modulate = Color.YELLOW


func process_state(_delta):
	if movement_component.is_close_to_target():
		movement_component.speed = 0.0

	return null
