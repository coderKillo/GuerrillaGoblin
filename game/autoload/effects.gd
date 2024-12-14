## contains static functions that create tweens to implement common effects
extends Node2D


func sprite_bounce(node: Node2D, strength: float = 0.2) -> void:
	var tween = node.get_tree().create_tween()

	tween.tween_property(node, "global_scale", Vector2(1.0 + strength, 1.0 - strength), 0.1)
	tween.tween_property(node, "global_scale", Vector2(1.0 - strength, 1.0 + strength), 0.2)
	tween.tween_property(node, "global_scale", Vector2(1.0, 1.0), 0.1)
