extends Node2D

signal weapon_done

@export var anticipation_time: float = 0.2
@export var reovery_time: float = 0.2

@export var ArrowScene := preload("res://game/character/weapon/arrow.tscn")

@export var weapon_sprite: Sprite2D
@export var normal_texture: Texture
@export var reload_texture: Texture

var _is_attacking := false


func _process(_delta):
	if _is_attacking:
		return

	look_at(get_global_mouse_position())


func is_attacking():
	return _is_attacking


func attack():
	if _is_attacking:
		return

	_is_attacking = true

	await get_tree().create_timer(anticipation_time).timeout

	var arrow = ArrowScene.instantiate()
	arrow.global_transform = global_transform
	arrow.top_level = true

	arrow.body_entered.connect(weapon_body_entered)

	owner.add_child(arrow)

	weapon_sprite.texture = reload_texture

	await get_tree().create_timer(reovery_time).timeout

	weapon_sprite.texture = normal_texture

	_is_attacking = false

	weapon_done.emit()


func weapon_body_entered(body):
	if body.has_method("hit"):
		body.hit()
