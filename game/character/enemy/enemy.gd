extends CharacterBody2D

@export var weapon: Node2D

@export var attack := false
@export var direction := Vector2.ZERO

var movement_speed := Settings.base_movement_speed

@onready var air_component: AirComponent = $AirComponent


func _physics_process(_delta):
	if attack and weapon:
		weapon.attack()
		attack = false

	weapon.look_at(global_position + direction)

	if air_component.is_in_air():
		pass
	elif weapon.is_attacking():
		velocity = Vector2.ZERO
	elif direction:
		velocity = direction * movement_speed
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.5)

	move_and_slide()
