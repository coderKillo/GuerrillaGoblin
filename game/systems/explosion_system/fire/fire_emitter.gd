class_name FireEmitter
extends Node

signal emitter_collided

@export var _emitter: EmitterArea
@export var _shape: CollisionShape3D
@export var _stack_init_value: int = 0

var _stack := 0


func _ready():
	assert(_emitter)
	assert(_shape)

	_shape.disabled = true
	_stack = _stack_init_value


func _process(_delta):
	print(_stack)
	if _stack <= 0:
		_shape.disabled = false
		return

	_shape.disabled = true

	print(_emitter.body_collided)
	if _emitter.body_collided > 0:
		_stack -= 1
		_emitter.body_collided = 0


func disabled(value: bool):
	set_process(!value)


func add_fire(amount: int = 1):
	_stack += amount


func fire_stack() -> int:
	return _stack
