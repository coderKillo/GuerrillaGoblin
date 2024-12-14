@tool
extends Entity2D

const EXPLOSION_DELAY = 0.75
const EXPLOSION_FORCE = 5.0

@export var light_damage_sprite: Node2D
@export var heavy_damage_sprite: Node2D
@export var destroy_sprite: Node2D

@onready var ExplosionScene := preload("res://game/entities/barrel/exposion.tscn") as PackedScene

var _destroied = false
var _hits = 0


func hit(count: int = 1) -> void:
	if _destroied:
		return

	Effects.sprite_bounce(model_2d)

	_hits += count

	match _hits:
		1:
			light_damage_sprite.show()
		2:
			heavy_damage_sprite.show()
		_:
			_destroy()


func _destroy() -> void:
	_destroied = true

	var delay = EXPLOSION_DELAY
	# explosions on some specific positions, can also change to export
	for pos in [Vector2(-38, -24), Vector2(26, 0), Vector2(0, -70)]:
		var explosion := ExplosionScene.instantiate()
		explosion.position.x = pos.x
		explosion.model_2d.offset.y = pos.y
		explosion.explosion_force = EXPLOSION_FORCE

		add_child(explosion)

		delay -= (EXPLOSION_DELAY / 3.0)
		await get_tree().create_timer(delay).timeout

	# children like fire or facade are no longer required
	for child in model_2d.get_children():
		child.hide()

	destroy_sprite.show()
