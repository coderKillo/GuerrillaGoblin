@tool
extends Entity2D

@export var explosion_delay := 3.0

@onready var ExplosionScene := preload("res://game/entities/barrel/exposion.tscn") as PackedScene

var _hit = 0
var _destroyed = false


func hit(count: int = 1) -> void:
	_hit += count

	match _hit:
		1:
			_ignite()
		_:
			_destroy()


func _ignite():
	Effects.sprite_bounce(model_2d)

	model_2d.get_node("Animation").play("ignite")

	await get_tree().create_timer(explosion_delay).timeout

	_destroy()


func _destroy():
	_destroyed = true

	var explosion = ExplosionScene.instantiate()
	explosion.global_position = global_position

	get_parent().add_child(explosion)

	queue_free()
