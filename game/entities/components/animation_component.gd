extends Node

@export var _animation: AnimatedSprite2D

@onready var _movement_component: MovementComponent = $"../MovementComponent"


func _ready():
	assert(_movement_component)
	assert(_animation)


func _process(_delta):
	if _movement_component.is_moving():
		_animation.play("move")
	else:
		_animation.play("idle")

	_flip_sprite()


func _flip_sprite():
	var mouse_position = _animation.get_global_mouse_position()
	var direction = _animation.global_position.direction_to(mouse_position)
	var ortho_angle = rad_to_deg(direction.orthogonal().angle())

	if ortho_angle > 0:
		_animation.flip_h = true
	else:
		_animation.flip_h = false
