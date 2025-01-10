extends CharacterBody2D

@export var weapon: Node2D

var speed := Settings.base_movement_speed

@onready var air_component: AirComponent = $AirComponent


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("attack"):
		weapon.attack()


func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if weapon.is_attacking():
		direction = Vector2.ZERO
	else:
		weapon.look_at(get_global_mouse_position())

	if air_component.is_in_air():
		pass
	elif direction:
		velocity = direction * speed
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.5)

	move_and_collide(velocity * delta)


func hit(_count: int = 1):
	print("player hit")
