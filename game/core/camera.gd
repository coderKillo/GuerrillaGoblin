class_name Camera
extends Camera2D

var _target: Node2D


func _ready():
	Events.game_state_changed.connect(_on_game_state_changed)


func _process(_delta):
	if not _target:
		return

	global_position = _target.global_position


func _on_game_state_changed(state: Global.GameState):
	match state:
		Global.GameState.INIT:
			pass
		Global.GameState.CUTSCENE:
			_play_cutscene()
		Global.GameState.PLAY:
			_target = get_tree().get_nodes_in_group(Global.player_tag)[0]
		_:
			pass


func _play_cutscene() -> void:
	get_tree().paused = true

	var tween := get_tree().create_tween()

	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "zoom", Vector2.ONE * 0.5, 3.3).from(Vector2.ONE * 0.3)

	await tween.finished

	get_tree().paused = false

	Events.cutscene_finished.emit()
