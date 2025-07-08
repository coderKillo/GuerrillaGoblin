@tool
class_name Model2D
extends Node2D

@export var offset := Vector2.ZERO:
	set = set_offset

@export var flip_h := false:
	set = set_flip_h

@export var sprites: Array[Node2D]


func set_offset(value: Vector2):
	var diff = offset - value
	offset = value

	var z = floori(value.y / Globals.SCALE)

	for sprite in sprites:
		sprite.offset += diff
		sprite.z_index = z


func set_flip_h(value):
	for sprite in sprites:
		sprite.flip_h = value
