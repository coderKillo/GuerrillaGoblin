extends CanvasLayer

const SHADER_HEIGHT_IN = 1.0
const SHADER_HEIGHT_OUT = -1.0
const TRANSITION_TIME = 1.0

@onready var _transition: Control = $Transition

var _in_transition = false


func change_scene(scene: PackedScene) -> void:
	if _in_transition:
		return

	_in_transition = true

	await _do_transition(true)
	get_tree().change_scene_to_packed(scene)
	await _do_transition(false)

	_in_transition = false


func load_level(main_scene: PackedScene, level: PackedScene) -> void:
	if _in_transition:
		return

	_in_transition = true

	await _do_transition(true)

	var new_scene := main_scene.instantiate() as Main
	var tree = get_tree()
	var current_scene = tree.current_scene
	tree.root.add_child(new_scene)
	tree.root.remove_child(current_scene)
	tree.current_scene = new_scene

	# add level to world
	new_scene.world.add_child(level.instantiate())

	await _do_transition(false)

	_in_transition = false


# wait for transition to be finished
func _do_transition(transition_in: bool) -> void:
	var tween := get_tree().create_tween()
	var to = SHADER_HEIGHT_IN if transition_in else SHADER_HEIGHT_OUT
	var from = SHADER_HEIGHT_OUT if transition_in else SHADER_HEIGHT_IN
	var duration = TRANSITION_TIME / 2.0

	tween.tween_property(_transition, "material:shader_parameter/height", to, duration).from(from)

	await tween.finished
