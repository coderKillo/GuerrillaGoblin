extends CharacterBody2D

@export var speed := 500.0
@export var weapon: Node2D


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("attack"):
		weapon.attack()


func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if weapon.is_attacking():
		direction = Vector2.ZERO
	else:
		weapon.look_at(get_global_mouse_position())

	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.5)

	move_and_slide()
