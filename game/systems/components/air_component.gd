class_name AirComponent
extends Node2D

@export var character: CharacterBody2D

var air_velocity

var _height := 0.0
var _speed := 0.0


func _ready():
	assert(character)


func _process(delta):
	if _height > 0 or _speed > 0:
		_speed -= Settings.gravity * delta
		_height += _speed * delta
		character.global_scale = Vector2.ONE * (1 + _height / Settings.gravity)
		character.set_collision_mask_value(Global.water_layer, false)
	else:
		character.global_scale = Vector2.ONE
		character.set_collision_mask_value(Global.water_layer, true)


func is_in_air() -> bool:
	return _height > 0


func add_force(force: Vector3):
	_speed += force.z
	if is_in_air():
		character.velocity += Vector2(force.x, force.y)
	else:
		character.velocity = Vector2(force.x, force.y)
	air_velocity = character.velocity
