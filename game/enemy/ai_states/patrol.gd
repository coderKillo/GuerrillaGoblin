extends State

@export var seen_target: State
@export var walk_movement := 0.5

var _path: Array[Vector2]


func _ready():
	for child in owner.get_children():
		if child is Line2D:
			_path = _get_points_from_line(child)


func enter():
	movement_component.target_position = _path.front()
	movement_component.speed = walk_movement


func exit():
	_path.push_front(global_position)


func process_state(_delta):
	if movement_component.is_close_to_target():
		_path.push_back(_path.pop_front())
		movement_component.target_position = _path.front()

	movement_component.move_to_target()

	if target_component.is_target_seen_in_movement_direction(movement_component):
		return seen_target

	if listener_component.has_sound_heard():
		if listener_component.sound_string.contains("GOTO:"):
			var coord = listener_component.sound_string.split(":")[1]
			target_component.target_position = str_to_var("Vector2" + coord)
		else:
			target_component.target_position = listener_component.sound_position
		return seen_target

	return null


func _get_points_from_line(line: Line2D) -> Array[Vector2]:
	var path: Array[Vector2] = []

	for point in line.points:
		path.append(line.to_global(point))
	line.position = line.global_position
	line.top_level = true
	line.hide()

	return path
