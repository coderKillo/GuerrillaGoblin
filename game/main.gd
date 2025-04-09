class_name Main
extends Node2D

@onready var world: Node2D = %World
@onready var gui: Gui = %GUI
@onready var score: ScoreSystem = $ScoreSystem
@onready var camera: Camera = $Camera

var _elapsed_time := 0.0
var _tasks := {}


func _ready():
	Events.player_death.connect(_on_player_death)
	Events.task_register.connect(_on_task_register)
	Events.task_complete.connect(_on_task_complete)


func _process(delta: float):
	_elapsed_time += delta

	gui.hud().set_time(int(_elapsed_time))


func setup() -> void:
	Events.game_state_changed.emit(Global.GameState.INIT)

	Events.game_state_changed.emit(Global.GameState.CUTSCENE)

	# TODO:: pause world
	await Events.cutscene_finished

	Events.game_state_changed.emit(Global.GameState.PLAY)


func _on_player_death():
	_end_level(false)


func _on_task_register(text: String):
	if not _tasks.has(text):
		_tasks[text] = 0
	_tasks[text] += 1

	gui.hud().set_tasks(_tasks)


func _on_task_complete(text: String):
	_tasks[text] -= 1

	#if all complete
	gui.hud().update_tasks(_tasks)

	for number in _tasks.values():
		if number > 0:
			return

	_end_level(true)


func _end_level(success: bool):
	var time := floori(_elapsed_time)
	var score_points := score.calculate_score(time)
	gui.finish_screen(time, score_points, success)
