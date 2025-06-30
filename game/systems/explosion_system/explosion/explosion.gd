@tool
extends Entity25D

@onready var _animation: AnimatedSprite2D = $Model2D/AnimatedSprite2D


func _physics_process(_delta):
	if _animation.is_playing():
		return

	queue_free()
