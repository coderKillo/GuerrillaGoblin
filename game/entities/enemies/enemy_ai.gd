extends Node2D

@export var entity: Entity2D
@export var enemy: Enemy
@export var navigation: NavigationAgent3D

enum State { PATROL, IDLE, ATTACK, RUN_TO_POSITION }

var _current_state = State.IDLE
var _path: Array[Vector2]
var _player: Array[Entity2D]


func _ready():
	for child in owner.get_children():
		if child is Line2D:
			for point in child.points:
				_path.append(child.to_global(point))
			child.position = child.global_position
			child.top_level = true
			child.hide()
		if child is Marker2D:
			_path.append(child.global_position)
			child.position = child.global_position
			child.top_level = true

		for player_node in get_tree().get_nodes_in_group("player"):
			_player.append(player_node as Entity2D)


func _process(_delta):
	print(State.keys()[_current_state])

	match _current_state:
		State.IDLE:
			_current_state = State.PATROL

		State.PATROL:
			entity.modulate = Color.WHITE

			var player := _get_player_in_sight()
			if player:
				_path.push_front(entity.global_position)
				navigation.target_position = player.object_3d.global_position
				_current_state = State.RUN_TO_POSITION
				return

			if len(_path) <= 0:
				return

			if entity.global_position.distance_to(_path.front()) <= 5:
				_path.push_back(_path.pop_front())

			var target_position = _path.front()
			var direction = entity.global_position.direction_to(target_position)

			enemy.direction.z = direction.y
			enemy.direction.x = direction.x

		State.ATTACK:
			pass

		State.RUN_TO_POSITION:
			enemy.direction = Vector3.ZERO

			if navigation.is_navigation_finished():
				_current_state = State.PATROL
				return

			entity.modulate = Color.RED

			var direction = entity.object_3d.global_position.direction_to(
				navigation.get_next_path_position()
			)

			enemy.direction = direction


func _get_player_in_sight() -> Entity2D:
	var entity_in_sight: Entity2D
	var entity3d = entity.object_3d
	var space_state := entity3d.get_world_3d().direct_space_state

	for player in _player:
		var player3d = player.object_3d
		var direction = entity3d.global_position.direction_to(player3d.global_position)
		if enemy.direction.dot(direction) <= 0:
			continue

		var start = entity3d.global_position + Vector3.UP * 0.5
		var view_distance = 5

		var query = PhysicsRayQueryParameters3D.create(
			start, start + direction * view_distance, entity3d.collision_mask, [entity3d]
		)

		var result = space_state.intersect_ray(query)
		if not result or result.collider != player3d:
			continue

		var distance_to_player = entity3d.global_position.distance_to(player3d.global_position)
		var distance_to_entity = INF

		if entity_in_sight:
			distance_to_entity = entity3d.global_position.distance_to(
				entity_in_sight.object_3d.global_position
			)

		if distance_to_player > distance_to_entity:
			continue

		entity_in_sight = player

	return entity_in_sight
