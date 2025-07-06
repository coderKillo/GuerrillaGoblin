class_name ThrowComponent
extends Node

signal object_thrown(object: Node)

@export var _throw_time := 1.0
@export var _cooldown := 1.0
@export var _throw_object: PackedScene
@export var _origin: Node3D

@onready var _path: Path2D = $Path2D
@onready var _line: Line2D = $Line2D
@onready var _target_sprite: Sprite2D = $Target

var _disabled := false
var _cooldown_timer := 0.0
var _start_velocity := Vector3.ZERO


func _ready():
	disable(true)


func _process(delta):
	if _cooldown_timer > 0.0:
		_cooldown_timer -= delta


func disable(value: bool):
	_disabled = value
	_line.visible = !value
	_target_sprite.visible = !value


func update_arc(target: Vector3):
	if _disabled:
		return

	Math.set_arc(_path.curve, _origin.global_position, target, _throw_time)
	_line.clear_points()
	for point in _path.curve.get_baked_points():
		_line.add_point(point)

	_start_velocity = Math.arc_start_velocity(_origin.global_position, target, _throw_time)
	_target_sprite.global_position = Math.to_2d_vector(target)


func can_throw() -> bool:
	if _cooldown_timer > 0.0:
		return false
	return true


func throw():
	if _disabled:
		return
	if not can_throw():
		return

	_cooldown_timer = _cooldown

	var object: Entity25D = _throw_object.instantiate()
	if GameState.world:
		GameState.world.add_child(object)
	else:
		owner.owner.get_node("World").add_child(object)

	object.object_3d.global_position = _origin.global_position
	object.object_3d.apply_impulse(_start_velocity)

	object_thrown.emit(object)
