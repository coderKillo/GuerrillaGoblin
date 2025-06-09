@tool
class_name Model2D
extends Node2D

@export var offset := Vector2.ZERO:
	set = set_offset

var _sprites: Array[Node2D]


func set_offset(value):
	var diff = offset - value
	offset = value

	if _sprites.is_empty():
		Utils.findByClass(self, "Sprite2D", _sprites)
		Utils.findByClass(self, "AnimatedSprite2D", _sprites)

	for sprite in _sprites:
		sprite.offset += diff
