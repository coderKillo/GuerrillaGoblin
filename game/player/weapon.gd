class_name Weapon
extends Area2D

@onready var _collide_shape: CollisionShape2D = $WeaponCollision


func _ready():
	_collide_shape.disabled = true
	body_entered.connect(_on_body_entered)


func active(is_active: bool):
	_collide_shape.disabled = !is_active


func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit()
