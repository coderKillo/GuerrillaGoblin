extends Node

@export var target: Player


func _physics_process(_delta):
	if not target:
		return

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if not target.movement.character.is_on_floor():
			return
		target.movement.character.global_position.y += 1
		target.movement.added_velocity.y -= 9.5

	if Input.is_action_just_pressed("attack"):
		target.attack.attack()

	if Input.is_action_just_pressed("attack2"):
		target.throw.disable(false)

	if Input.is_action_just_released("attack2"):
		target.throw.throw()
		target.throw.disable(true)

	if Input.is_action_pressed("attack2"):
		target.throw.update_arc(Utils.get_global_mouse_position_3d(get_viewport()))

	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# if _is_attacking():
	# 	direction = Vector3.ZERO  # ignore input
	#
	target.movement.movement_direction = input_dir.normalized()
