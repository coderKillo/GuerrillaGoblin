extends Node3D

var _players: Array
var _goals: Array
var _target: Node3D
var _index: int = 1


func _ready():
	_players = get_tree().get_nodes_in_group("player")
	_goals = get_tree().get_nodes_in_group("goal")

	_select_player(_index)

	Events.lose.connect(_on_game_end.bind(false))
	Events.win.connect(_on_game_end.bind(true))


func _process(delta):
	if Input.is_action_just_pressed("next_player"):
		_change_index(+1)

	if Input.is_action_just_pressed("previous_player"):
		_change_index(-1)

	if is_instance_valid(_target):
		global_position = lerp(global_position, _target.global_position, delta * 5.0)
	else:
		_player_died()

	_goals = _goals.filter(func(e): return is_instance_valid(e))

	if _goals.size() <= 0:
		Events.win.emit()


func _physics_process(_delta):
	if not is_instance_valid(_target):
		return

	if Input.is_action_just_pressed("attack"):
		#var viewport := get_viewport()
		#var direction = viewport.get_mouse_position() - viewport.get_visible_rect().size / 2.0
		var mouse_pos = get_viewport().get_mouse_position()
		var origin = $Camera3D.project_ray_origin(mouse_pos)
		var end = origin + $Camera3D.project_ray_normal(mouse_pos) * 1000.0

		var query = PhysicsRayQueryParameters3D.create(origin, end)
		#query.collide_with_areas = true  # Enable Area3D detection
		var result = get_world_3d().direct_space_state.intersect_ray(query)

		if result:
			if result.collider is RigidBody3D:
				_target.attack(result.collider.global_position)
			else:
				_target.attack(result.position)

	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_target.direction = (
		(_target.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	)


func _change_index(delta: int):
	_index += delta

	if _index < 0:
		_index = _players.size() - 1

	elif _index >= _players.size():
		_index = 0

	_select_player(_index)


func _select_player(index: int):
	if is_instance_valid(_target):
		_target.direction = Vector3.ZERO

	if is_instance_valid(_players[index]):
		_target = _players[index]


func _player_died():
	_players.remove_at(_index)
	if _players.size() > 0:
		_change_index(0)
	else:
		Events.lose.emit()


func _on_game_end(win: bool):
	if win:
		%Label.text = "WIN!"
	else:
		%Label.text = "LOSE!"
