class_name WinScreen
extends Control


func _ready():
	%Next.pressed.connect(_on_next_pressed)
	%Restart.pressed.connect(_on_restart_pressed)
	%Quit.pressed.connect(_on_quit_pressed)

	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
	else:
		get_tree().paused = false


func setup(time_s: int, score: int):
	%Score.text = str(score)
	%Time.text = Utils.time_to_string(time_s)


func _on_next_pressed():
	get_tree().paused = false
	SceneChanger.load_level(GameState.current_level_index + 1)


func _on_restart_pressed():
	get_tree().paused = false
	SceneChanger.load_level(GameState.current_level_index)


func _on_quit_pressed():
	get_tree().paused = false
	SceneChanger.change_scene(Resources.main_screen_scene)
