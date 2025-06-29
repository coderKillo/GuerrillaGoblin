class_name GravityComponent
extends Node

signal hit_ground

@export var _movement: MovementComponent
@export var _force_emitter: ForceEmitter

var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _in_air = false


func _ready():
	assert(_movement)


func _process(delta):
	if not _movement.character.is_on_floor():
		_movement.added_velocity.y -= _gravity * delta
		_in_air = true
	elif _in_air:
		_hit_ground()
		_in_air = false


func _hit_ground():
	hit_ground.emit()

	if _force_emitter:
		_force_emitter.disable(false)
