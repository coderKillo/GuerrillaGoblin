extends CharacterBody3D

const SPEED = 5.0
const AIR_MOVEMENT_FACTOR = 0.04
const JUMP_VELOCITY = 9.5
const PUSH_FORCE = 1.0

@export var animation: AnimationPlayer
@export var entity_2d: Entity2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var _body_direction = "left"
var _aim_direction = "left"


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("attack") and not _is_attacking():
		_attack()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if _is_attacking():
		direction = Vector3.ZERO  # ignore input

	if not is_on_floor():
		velocity.x = move_toward(velocity.x, direction.x * SPEED, AIR_MOVEMENT_FACTOR)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, AIR_MOVEMENT_FACTOR)
	elif direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	_update_direction()
	_update_animation()

	move_and_slide()

	_push_rigidbodies()


func _is_attacking() -> bool:
	return animation.current_animation.contains("attack")


func _attack() -> void:
	animation.play("attack_%s" % _aim_direction)


func _update_direction():
	if velocity.x < 0:
		_body_direction = "left"
	elif velocity.x > 0:
		_body_direction = "right"

	var direction_to_mouse = entity_2d.global_position.direction_to(
		entity_2d.get_global_mouse_position()
	)

	if abs(direction_to_mouse.x) > abs(direction_to_mouse.y):
		if direction_to_mouse.x < 0:
			_aim_direction = "left"
		if direction_to_mouse.x > 0:
			_aim_direction = "right"
	else:
		if direction_to_mouse.y > 0:
			_aim_direction = "down"
		if direction_to_mouse.y < 0:
			_aim_direction = "up"


func _update_animation():
	if _is_attacking():
		return

	if velocity.length() > 0:
		animation.play("walk_%s" % _body_direction)
	else:
		animation.play("idle_%s" % _body_direction)


func _on_weapon_body_entered(body: PhysicsBody3D):
	if body.owner.has_method("hit"):
		body.owner.hit()


func _push_rigidbodies():
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as RigidBody3D
		if not body:
			continue

		var push_dir = -collision.get_normal()
		body.apply_central_impulse(push_dir * PUSH_FORCE)
