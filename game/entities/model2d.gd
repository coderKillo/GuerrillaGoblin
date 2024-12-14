@tool
class_name Model2D
extends Node2D

@export var offset := Vector2.ZERO:
	set = set_offset


func set_offset(value):
	var diff = offset - value
	offset = value

	var sprites = []
	findByClass(self, "Sprite2D", sprites)
	findByClass(self, "AnimatedSprite2D", sprites)

	for sprite in sprites:
		sprite.offset += diff


func findByClass(node: Node, className: String, result: Array) -> void:
	if node.is_class(className):
		result.push_back(node)
	for child in node.get_children():
		findByClass(child, className, result)
