extends Node2D


func spawn_sound(pos: Vector2, radius: float, sound: String, group: StringName = ""):
	for listener in get_tree().get_nodes_in_group("listener"):
		if listener.global_position.distance_to(pos) > radius:
			continue
		if group and not listener.owner.is_in_group(group):
			continue
		if listener.has_method("on_hear_sound"):
			listener.on_hear_sound(sound, pos)


func sprite_bounce(node: Node2D, strength: float = 0.2) -> void:
	var tween = node.get_tree().create_tween()
	var offset_scale = Vector2(strength, -strength)

	tween.tween_property(node, "global_scale", Vector2.ONE + offset_scale, 0.1)
	tween.tween_property(node, "global_scale", Vector2.ONE + offset_scale / 2.0, 0.2)
	tween.tween_property(node, "global_scale", Vector2.ONE, 0.2)


func _unhandled_input(event):
	if event.is_action_pressed("spawn_sound"):
		spawn_sound(get_global_mouse_position(), 1000, "BANG")
