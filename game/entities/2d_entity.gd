@tool
class_name Entity2D
extends Node2D

const SCALE = 64
const BASE_VECTOR = Vector3(1.0, 0.707, 0.707)

@export var object_3d: Node3D
@export var model_2d: Model2D
@export var y_level: int:
	set(value):
		model_2d.offset.y = float(value) * SCALE
	get:
		return int(model_2d.offset.y / SCALE)


func _ready():
	_sync_3d_object()

	_ready_25d()


func _process(delta):
	if Engine.is_editor_hint():
		_sync_3d_object()
	else:
		_sync_2d_object()

	_process_25d(delta)


# abstract
func _ready_25d():
	pass


# abstract
func _process_25d(_delta):
	pass


func _sync_3d_object():
	assert(model_2d is Model2D, "%s" % self.name)
	object_3d.global_position = Entity2D.to_3d(global_position, model_2d.offset.y)


func _sync_2d_object():
	var data = Entity2D.to_2d(object_3d.global_position)
	global_position = data.position
	model_2d.offset.y = data.offset


static func to_2d(vector: Vector3) -> Dictionary:
	return {
		position = Vector2(vector.x * SCALE * BASE_VECTOR.x, vector.z * SCALE * BASE_VECTOR.z),
		offset = vector.y * SCALE * BASE_VECTOR.y
	}


static func to_3d(vector: Vector2, offset: float) -> Vector3:
	return Vector3(
		vector.x / SCALE / BASE_VECTOR.x,
		offset / SCALE / BASE_VECTOR.y,
		vector.y / SCALE / BASE_VECTOR.z
	)
