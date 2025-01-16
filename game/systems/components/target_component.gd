class_name TargetComponent
extends Node2D

@export var target_group: String = ""
@export var view_distance: float = 500.0
@export var agent: CharacterBody2D

var target: Node2D
var target_position: Vector2


func is_target_seen_in_movement_direction(movement_component: MovementComponent) -> bool:
	return is_target_seen(
		movement_component.direction,
		movement_component.character.collision_mask,
		[movement_component.character]
	)


func is_target_seen(
	view_direction: Vector2, _collision_mask: int = 0, _exclude: Array = []
) -> bool:
	var closest_target: Node2D

	for entity in get_tree().get_nodes_in_group(target_group):
		var direction = global_position.direction_to(entity.global_position)
		if view_direction.normalized().dot(direction) <= 0:
			continue

		var start = global_position

		var query = PhysicsRayQueryParameters2D.create(
			start, start + direction * view_distance, agent.collision_mask, [agent]
		)

		var result = get_world_2d().direct_space_state.intersect_ray(query)
		if not result or result.collider != entity:
			continue

		var distance_to_target = global_position.distance_to(entity.global_position)
		var distance_to_closest_target = INF

		if closest_target:
			distance_to_closest_target = global_position.distance_to(closest_target.global_position)

		if distance_to_target > distance_to_closest_target:
			continue

		closest_target = entity

	if closest_target:
		target = closest_target
		target_position = closest_target.global_position
		return true
	else:
		target = null
		return false
