extends CharacterBody2D

@export var movement_speed := 500.0
@export var weapon: Node2D

@export var attack := false
@export var direction := Vector2.ZERO


func _physics_process(_delta):
	if attack:
		weapon.attack()
		attack = false

	weapon.look_at(global_position + direction)

	if weapon.is_attacking():
		velocity = Vector2.ZERO
	if direction:
		velocity = direction * movement_speed
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.5)

	move_and_slide()
