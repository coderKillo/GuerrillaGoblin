extends Node2D


func spawn_sound(pos: Vector2, radius: float, sound: String):
	for listener in get_tree().get_nodes_in_group("listener"):
		if listener.global_position.distance_to(pos) > radius:
			continue
		if listener.has_method("on_hear_sound"):
			listener.on_hear_sound(sound, pos)


func sprite_bounce(node: Node2D, strength: float = 0.2) -> void:
	var tween = node.get_tree().create_tween()

	tween.tween_property(node, "global_scale", Vector2(1.0 + strength, 1.0 - strength), 0.1)
	tween.tween_property(node, "global_scale", Vector2(1.0 - strength, 1.0 + strength), 0.2)
	tween.tween_property(node, "global_scale", Vector2(1.0, 1.0), 0.1)


func _unhandled_input(event):
	if event.is_action_pressed("spawn_sound"):
		spawn_sound(get_global_mouse_position(), 300, "BANG")
