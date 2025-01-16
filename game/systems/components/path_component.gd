class_name PathComponent
extends Node2D

var _path: Array[Vector2]


func front() -> Vector2:
	return _path.front()


func next_point() -> Vector2:
	_path.push_back(_path.pop_front())
	return _path.front()


func push_front(point: Vector2):
	_path.push_front(point)


func _ready():
	for child in owner.get_children():
		if child is Line2D:
			_path = _get_points_from_line(child)


func _get_points_from_line(line: Line2D) -> Array[Vector2]:
	var path: Array[Vector2] = []

	for point in line.points:
		path.append(line.to_global(point))
	line.position = line.global_position
	line.top_level = true
	line.hide()

	return path
