@tool
class_name Entity25D
extends Node2D

@export var object_3d: Node3D
@export var model_2d: Model2D
@export var y_level: int:
	set(value):
		model_2d.offset.y = float(value) * Globals.SCALE
	get:
		return int(model_2d.offset.y / Globals.SCALE)


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
	object_3d.global_position = Math.to_3d(global_position, model_2d.offset.y)


func _sync_2d_object():
	var data = Math.to_2d(object_3d.global_position)
	global_position = data.position
	model_2d.offset.y = data.offset
