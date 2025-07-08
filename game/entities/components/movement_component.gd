class_name MovementComponent
extends Node

@export var character: CharacterBody3D

@export_group("config")
@export var speed: float = 5.0
@export var air_movement_factor: float = 0.2

var movement_direction := Vector2.ZERO
var added_velocity := Vector3.ZERO

var velocity: Vector3:
	set(value):
		character.velocity = value
	get:
		return character.velocity

var _max_air_speed := 0.0


func _process(_delta):
	if not character.is_on_floor():
		var air_velocity_xz = _get_air_velocity()
		print(air_velocity_xz)

		velocity.x = air_velocity_xz.x
		velocity.z = air_velocity_xz.y

	elif movement_direction:
		velocity.x = movement_direction.x * speed
		velocity.z = movement_direction.y * speed

	else:
		_max_air_speed = 0.0

		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	velocity += added_velocity
	added_velocity = Vector3.ZERO

	character.move_and_slide()


func is_moving() -> bool:
	return velocity.length() > 0


func _get_air_velocity() -> Vector2:
	var velocity_xz = Vector2(velocity.x, velocity.z)
	_max_air_speed = max(_max_air_speed, velocity_xz.length())
	_max_air_speed = max(_max_air_speed, speed)

	velocity_xz.x += movement_direction.x * air_movement_factor
	velocity_xz.y += movement_direction.y * air_movement_factor

	var air_speed = min(_max_air_speed, velocity_xz.length())
	velocity_xz = velocity_xz.normalized() * air_speed

	return velocity_xz
