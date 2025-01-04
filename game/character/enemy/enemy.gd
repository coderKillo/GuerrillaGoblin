extends CharacterBody2D

@export var speed := 500.0
@export var weapon: Node2D

var attack := false
var direction := Vector2.ZERO


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("attack"):
		weapon.attack()


func _physics_process(_delta):
	if weapon.is_attacking():
		direction = Vector2.ZERO

	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.5)

	move_and_slide()
