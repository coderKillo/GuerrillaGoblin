@tool
extends Entity25D

@export var _fire_detector: FireDetector
@export var _force_detector: ForceDetector
@export var _explosion_offset := -0.5

@onready var _animation = $Model2D/AnimatedSprite2D


func _ready_25d():
	_fire_detector.ignited.connect(_on_ignited)
	_force_detector.force_detected.connect(_on_force_detected)


func _on_ignited():
	_animation.play("hit")


func _on_force_detected(_force: Vector3):
	if _fire_detector.is_ignited:
		var explosion = Resources.explosion_scene.instantiate()
		get_parent().add_child(explosion)
		explosion.object_3d.global_position = object_3d.global_position
		explosion.object_3d.global_position.y += _explosion_offset
		queue_free()
