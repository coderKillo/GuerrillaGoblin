class_name Bow
extends Node2D

@export var target_component: TargetComponent

var ArrowScene: PackedScene = preload("res://game/enemy/arrow.tscn")


func fire():
	if not target_component.target:
		return

	var arrow = ArrowScene.instantiate()

	arrow.top_level = true
	arrow.global_position = global_position
	arrow.look_at(target_component.target.global_position)

	add_child(arrow)
