class_name Bow
extends Node2D

@export var _brain: EnemyAi

var ArrowScene: PackedScene = preload("res://game/enemy/arrow.tscn")


func fire():
	if not _brain.target:
		return

	var arrow = ArrowScene.instantiate()

	arrow.top_level = true
	arrow.global_position = global_position
	arrow.look_at(_brain.target.global_position)

	add_child(arrow)
