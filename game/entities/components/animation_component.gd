extends Node

const UP_DOWN_ANGLE_TOLERANCE = 25

@export var _model: Model2D

@onready var _movement_component: MovementComponent = $"../MovementComponent"
@onready var _attack_component: AttackComponent = $"../AttackComponent"

var _block_animation := false
var _animations: Array[AnimatedSprite2D]


func _ready():
	assert(_movement_component)
	assert(_attack_component)
	assert(_model)

	_attack_component.attacking.connect(_on_attacking)

	for child in _model.get_children():
		if child is AnimatedSprite2D:
			_animations.append(child)


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
	if _animations.is_empty():
		return
	if _block_animation:
		return

	for item in _animations:
		item.play(animation)

	if once:
		_block_animation = true
		await _animations[0].animation_finished
		_block_animation = false


func _flip_sprite():
	for item in _animations:
		if _get_aim_ortho_angle() > 0:
			item.flip_h = true
		else:
			item.flip_h = false


func _get_aim_ortho_angle() -> float:
	var mouse_position = _model.get_global_mouse_position()
	var direction = _model.global_position.direction_to(mouse_position)
	return rad_to_deg(direction.orthogonal().angle())


func _is_aim_up() -> bool:
	return abs(_get_aim_ortho_angle()) > (180 - UP_DOWN_ANGLE_TOLERANCE)


func _is_aim_down() -> bool:
	return abs(_get_aim_ortho_angle()) < UP_DOWN_ANGLE_TOLERANCE
