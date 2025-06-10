extends Node

@export var _animation : AnimatedSprite2D

@onready var _movement_component : MovementComponent =  $"../MovementComponent"
@onready var _facing_component : FacingComponent =  $"../FacingComponent"

func _ready():
	assert(_movement_component)
	assert(_animation)

func _process(_delta):
	if _movement_component.is_moving():
		_animation.play("move")
	else:
		_animation.play("idle")
	
