class_name EnemyAi
extends Node2D

@export var view_distance := 500
@export var attack_distance := 60
@export var min_distance := 5
@export var alert := 1.0
@export var look_around := 5.0
@export var walk_movement := 0.5
@export var run_movement := 1.2
@export var stay_on_position := false

@export var _agent: NavigationAgent2D

var target: Player

var _enemy: Enemy
var _path: Array[Vector2]

enum State { PATROL, ALERT, INVESTIGATE, LOOK_AROUND, CHASE }

var _current_state := State.PATROL:
	set = _set_state

var _alert_timer := alert
var _look_around_timer := look_around


func _ready():
	assert(owner is Enemy)
	_enemy = owner

	_init_patrol()

	_current_state = State.PATROL


func _process(delta):
	match _current_state:
		State.PATROL:
			_patrol()

			if _is_player_seen():
				_current_state = State.ALERT

		State.ALERT:
			_alert(delta)

			if _alert_timer <= 0.0:
				_current_state = State.INVESTIGATE

		State.INVESTIGATE:
			if stay_on_position:
				_current_state = State.LOOK_AROUND
				Effects.spawn_sound(_agent.target_position, 300, "BANG")
				return

			_investigate()

			if _is_player_seen():
				_current_state = State.CHASE

			if global_position.distance_to(_agent.target_position) < min_distance:
				_current_state = State.LOOK_AROUND

		State.LOOK_AROUND:
			_look_around(delta)

			if _is_player_seen():
				_current_state = State.CHASE

			if _look_around_timer <= 0.0:
				_current_state = State.PATROL

		State.CHASE:
			_chase()
			if not _is_player_seen():
				_current_state = State.INVESTIGATE


func on_hear_sound(_sound: String, pos: Vector2):
	_agent.target_position = pos

	match _current_state:
		State.PATROL:
			_agent.target_position = pos
			_current_state = State.ALERT

		State.ALERT:
			_agent.target_position = pos

		State.INVESTIGATE:
			_agent.target_position = pos

		State.LOOK_AROUND:
			_agent.target_position = pos
			_current_state = State.INVESTIGATE

		State.CHASE:
			pass


func _set_state(new_state):
	match new_state:
		State.PATROL:
			_enemy.speed = walk_movement
			_agent.target_position = _path.front()

		State.ALERT:
			_enemy.speed = 0.0

		State.INVESTIGATE:
			_enemy.speed = walk_movement if _current_state == State.ALERT else run_movement

		State.LOOK_AROUND:
			_enemy.speed = 0.0
			_look_around_timer = look_around

		State.CHASE:
			_enemy.speed = run_movement if not stay_on_position else 0.0

	_current_state = new_state


func _init_patrol():
	for child in _enemy.get_children():
		if child is Line2D:
			for point in child.points:
				_path.append(child.to_global(point))
			child.position = child.global_position
			child.top_level = true
			child.hide()


func _patrol():
	if global_position.distance_to(_path.front()) < min_distance:
		_path.push_back(_path.pop_front())
		_agent.target_position = _path.front()

	_enemy.direction = global_position.direction_to(_agent.get_next_path_position())


func _alert(delta):
	_enemy.modulate = Color.YELLOW
	_alert_timer -= delta


func _investigate():
	_enemy.direction = global_position.direction_to(_agent.get_next_path_position())

	_enemy.modulate = Color.YELLOW


func _look_around(delta):
	_enemy.modulate = Color.YELLOW
	_look_around_timer -= delta


func _chase():
	_enemy.modulate = Color.RED

	if stay_on_position:
		_enemy.direction = global_position.direction_to(_agent.target_position)
		_enemy.speed = 0.0
	else:
		_enemy.direction = global_position.direction_to(_agent.get_next_path_position())

	if global_position.distance_to(_agent.target_position) < attack_distance:
		_enemy.attack = true


func _is_player_seen() -> bool:
	var closest_player: Node2D

	for player in get_tree().get_nodes_in_group("player"):
		var direction = global_position.direction_to(player.global_position)
		if _enemy.direction.normalized().dot(direction) <= 0:
			continue

		var start = global_position

		var query = PhysicsRayQueryParameters2D.create(
			start, start + direction * view_distance, _enemy.collision_mask, [_enemy]
		)

		var result = get_world_2d().direct_space_state.intersect_ray(query)
		if not result or result.collider != player:
			continue

		var distance_to_player = global_position.distance_to(player.global_position)
		var distance_to_entity = INF

		if closest_player:
			distance_to_entity = global_position.distance_to(closest_player.global_position)

		if distance_to_player > distance_to_entity:
			continue

		closest_player = player

	if closest_player:
		_agent.target_position = closest_player.global_position
		target = closest_player
		return true
	else:
		target = null
		return false
