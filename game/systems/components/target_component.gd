class_name TargetComponent
extends Node2D

@export var target_group: String = ""
@export var view_distance: float = 500.0
@export var character: CharacterBody2D

var target: Node2D
var last_target_position: Vector2


func is_target_seen(view_direction: Vector2, view_angle: float) -> bool:
	for entity in get_targets_by_distance(target_group):
		if not _is_in_view_direction(entity.global_position, view_direction, view_angle):
			continue

		if _is_blocked_by_obstical(entity):
			continue

		target = entity
		last_target_position = entity.global_position
		return true

	target = null
	return false


func get_targets_by_distance(group: String) -> Array[Node]:
	var targets = get_tree().get_nodes_in_group(group)
	targets.sort_custom(_distance_sorter)
	return targets


func _is_in_view_direction(
	entity_position: Vector2, view_direction: Vector2, view_angle: float
) -> bool:
	var direction = global_position.direction_to(entity_position)
	return abs(rad_to_deg(view_direction.angle_to(direction))) <= view_angle


func _is_blocked_by_obstical(entity: Node2D) -> bool:
	var direction = global_position.direction_to(entity.global_position)
	var start = global_position
	var query = PhysicsRayQueryParameters2D.create(
		start, start + direction * view_distance, character.collision_mask, [character]
	)

	var result = get_world_2d().direct_space_state.intersect_ray(query)
	return not result or result.collider != entity


func _distance_sorter(a: Node2D, b: Node2D) -> bool:
	var distance_a = a.global_position.distance_squared_to(global_position)
	var distance_b = b.global_position.distance_squared_to(global_position)
	return distance_a <= distance_b
