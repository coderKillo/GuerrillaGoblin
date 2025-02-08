extends State

@export var arrive_at_position: State


func enter():
	movement_component.speed = Settings.run_speed
	movement_component.move_to(_get_closest_guard())
	movement_component.character.modulate = Color.YELLOW


func process_state(_delta):
	if movement_component.is_close_to_target():
		return arrive_at_position

	return null


func _get_closest_guard() -> Vector2:
	var closest_target: Node2D
	for entity in get_tree().get_nodes_in_group("guard"):
		var distance_to_target = global_position.distance_to(entity.global_position)
		var distance_to_closest_target = INF

		if closest_target:
			distance_to_closest_target = global_position.distance_to(closest_target.global_position)

		if distance_to_target > distance_to_closest_target:
			continue

		closest_target = entity

	if closest_target:
		return closest_target.global_position
	else:
		return global_position
