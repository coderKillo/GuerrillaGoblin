extends Node


func _ready():
	await get_parent().ready
	for node in get_tree().get_nodes_in_group(Globals.BUTTON_GROUP):
		if not node is AnimatedButton:
			continue

		node.mouse_entered.connect(_on_mouse_entered.bind(node))
		node.mouse_exited.connect(_on_mouse_exited.bind(node))
		node.button_down.connect(_on_button_down.bind(node))
		node.button_up.connect(_on_button_up.bind(node))


func _on_mouse_entered(node: AnimatedButton) -> void:
	_do_animation(node, "scale", node.scale_normal, node.scale_up, node.time)


func _on_mouse_exited(node: AnimatedButton) -> void:
	_do_animation(node, "scale", node.scale_up, node.scale_normal, node.time)


func _on_button_down(node: AnimatedButton) -> void:
	_do_animation(node, "scale", node.scale_normal, node.scale_pressed, node.time)
	_do_animation(node, "rotation", node.rotation_normal, node.rotation_pressed, node.time)


func _on_button_up(node: AnimatedButton) -> void:
	_do_animation(node, "scale", node.scale_pressed, node.scale_normal, node.time)
	_do_animation(node, "rotation", node.rotation_pressed, node.rotation_normal, node.time)


func _do_animation(
	object: Object, parameter: String, from: Variant, to: Variant, time: float
) -> void:
	if not is_inside_tree():
		return
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_parallel(true)
	(
		tween
		. tween_property(object.get_node("Content"), parameter, to, time)
		. from(from)
		. set_trans(Tween.TRANS_ELASTIC)
		. set_ease(Tween.EASE_OUT)
	)
