extends Node

const UP_DOWN_ANGLE_TOLERANCE = 25

@export var _animation: AnimatedSprite2D

@onready var _movement_component: MovementComponent = $"../MovementComponent"
@onready var _attack_component: AttackComponent = $"../AttackComponent"

var _block_animation := false


func _ready():
	assert(_movement_component)
	assert(_attack_component)
	assert(_animation)

	_attack_component.attacking.connect(_on_attacking)


func _process(_delta):
	if _movement_component.is_moving():
		_play_animation("move")

	else:
		_play_animation("idle")

	_flip_sprite()


func _on_attacking():
	if _is_aim_up():
		_play_animation("attack_up", true)
	elif _is_aim_down():
		_play_animation("attack_down", true)
	else:
		_play_animation("attack", true)


func _play_animation(animation: String, once: bool = false):
	if _block_animation:
		return

	_animation.play(animation)

	if once:
		_block_animation = true
		await _animation.animation_finished
		_block_animation = false


func _flip_sprite():
	if _get_aim_ortho_angle() > 0:
		_animation.flip_h = true
	else:
		_animation.flip_h = false


func _get_aim_ortho_angle() -> float:
	var mouse_position = _animation.get_global_mouse_position()
	var direction = _animation.global_position.direction_to(mouse_position)
	return rad_to_deg(direction.orthogonal().angle())


func _is_aim_up() -> bool:
	return abs(_get_aim_ortho_angle()) > (180 - UP_DOWN_ANGLE_TOLERANCE)


func _is_aim_down() -> bool:
	return abs(_get_aim_ortho_angle()) < UP_DOWN_ANGLE_TOLERANCE
