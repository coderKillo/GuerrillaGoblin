@tool
class_name Model2D
extends Node2D

@export var offset := Vector2.ZERO:
	set = set_offset

@export var flip_h := false:
	set = set_flip_h

@export var sprites: Array[Node2D]


func set_offset(value):
	var diff = offset - value
	offset = value

	for sprite in sprites:
		sprite.offset += diff


func set_flip_h(value):
	for sprite in sprites:
		sprite.flip_h = value
