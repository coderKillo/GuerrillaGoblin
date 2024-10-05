class_name Player
extends CharacterBody2D

enum PlayerAction { IDLE, WALK, ATTACK }

@export var movement_speed: float = 300.0
@export var attack_duration: float = 0.7

var _facing: int = Direction.RIGHT
var _action: PlayerAction = PlayerAction.IDLE


func _physics_process(_delta):
	# TODO: dont move when attacking?
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * movement_speed
	move_and_slide()


func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		_attack()


func _process(_delta):
	_process_player_state()
	_set_animation()


func _process_player_state():
	if _action == PlayerAction.ATTACK:
		return

	if velocity.length_squared() > 0.05:
		_action = PlayerAction.WALK
	else:
		_action = PlayerAction.IDLE

	var facing_angle_rad = global_position.angle_to_point(get_global_mouse_position())
	_facing = Direction.from_angle(facing_angle_rad)


func _set_animation():
	var animation := %Animation as AnimatedSprite2D

	match _action:
		PlayerAction.IDLE:
			animation.play("idle")
		PlayerAction.WALK:
			animation.play("walk")
		PlayerAction.ATTACK:
			match _facing:
				Direction.RIGHT_DOWN, Direction.LEFT_DOWN:
					animation.flip_h = false
					animation.play("attack_down")
				Direction.LEFT:
					animation.flip_h = true
					animation.play("attack_right")
				Direction.RIGHT_UP, Direction.LEFT_UP:
					animation.flip_h = false
					animation.play("attack_up")
				Direction.RIGHT:
					animation.flip_h = false
					animation.play("attack_right")

	match _facing:
		Direction.LEFT_UP, Direction.LEFT_DOWN, Direction.LEFT:
			animation.flip_h = true
		Direction.RIGHT_UP, Direction.RIGHT_DOWN, Direction.RIGHT:
			animation.flip_h = false


func _attack():
	if _action == PlayerAction.ATTACK:
		return

	_action = PlayerAction.ATTACK
	await get_tree().create_timer(attack_duration).timeout
	_action = PlayerAction.IDLE
