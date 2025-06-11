extends Node

@export var target: Player


func _physics_process(_delta):
	if not target:
		return

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		target.movement.jump()

	if Input.is_action_just_pressed("attack"):
		target.attack.attack()

	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# if _is_attacking():
	# 	direction = Vector3.ZERO  # ignore input
	#
	target.movement.movement_direction = input_dir.normalized()
