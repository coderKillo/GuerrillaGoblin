extends CharacterBody2D

var explosion_delay := Settings.barrel_explosion_delay

@onready var ExplosionScene := preload("res://game/objects/explosion.tscn") as PackedScene
@onready var air_component: AirComponent = $AirComponent

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
	modulate = Color.RED

	await get_tree().create_timer(explosion_delay).timeout

	_destroy()


func _destroy():
	_destroyed = true

	var explosion = ExplosionScene.instantiate()
	explosion.global_position = global_position

	get_parent().add_child(explosion)

	queue_free()


func _physics_process(_delta):
	if air_component.is_in_air():
		pass
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.5)

	move_and_slide()
