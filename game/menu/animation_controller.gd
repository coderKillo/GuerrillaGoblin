extends Node

const BUTTON_GROUP = "button"

# Values for button animations
const ANIM_VALUES_BUTTON: Dictionary = {
	"scale_normal": Vector2.ONE,
	"scale_up": Vector2(1.2, 1.2),
	"scale_pressed": Vector2(0.6, 0.6),
	"rotation_normal": 0.0,
	"rotation_pressed": 0.1,
	"time": 1.2,
}


func _ready():
	await get_parent().ready
	for button_node in get_tree().get_nodes_in_group(BUTTON_GROUP):
		button_node.mouse_entered.connect(_on_mouse_entered.bind(button_node))
		button_node.mouse_exited.connect(_on_mouse_exited.bind(button_node))
		button_node.button_down.connect(_on_button_down.bind(button_node))
		button_node.button_up.connect(_on_button_up.bind(button_node))


func _on_mouse_entered(button_node: Object) -> void:
	_do_animation(
		button_node,
		"scale",
		ANIM_VALUES_BUTTON.scale_normal,
		ANIM_VALUES_BUTTON.scale_up,
		ANIM_VALUES_BUTTON.time
	)


func _on_mouse_exited(button_node: Object) -> void:
	_do_animation(
		button_node,
		"scale",
		ANIM_VALUES_BUTTON.scale_up,
		ANIM_VALUES_BUTTON.scale_normal,
		ANIM_VALUES_BUTTON.time
	)


func _on_button_down(button_node: Object) -> void:
	_do_animation(
		button_node,
		"scale",
		ANIM_VALUES_BUTTON.scale_normal,
		ANIM_VALUES_BUTTON.scale_pressed,
		ANIM_VALUES_BUTTON.time
	)

	_do_animation(
		button_node,
		"rotation",
		ANIM_VALUES_BUTTON.rotation_normal,
		ANIM_VALUES_BUTTON.rotation_pressed,
		ANIM_VALUES_BUTTON.time
	)


func _on_button_up(button_node: Object) -> void:
	_do_animation(
		button_node,
		"scale",
		ANIM_VALUES_BUTTON.scale_pressed,
		ANIM_VALUES_BUTTON.scale_normal,
		ANIM_VALUES_BUTTON.time
	)

	_do_animation(
		button_node,
		"rotation",
		ANIM_VALUES_BUTTON.rotation_pressed,
		ANIM_VALUES_BUTTON.rotation_normal,
		ANIM_VALUES_BUTTON.time
	)


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
