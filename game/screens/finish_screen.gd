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


func setup(time_s: int, score: int, success: bool):
	%Score.text = str(score)
	%ScoreContainer.visible = success

	%Time.text = Gui.time_to_string(time_s)
	%TimeContainer.visible = success

	%Next.visible = success


func _on_next_pressed():
	get_tree().paused = false
	SceneChanger.load_level(Gamestate.current_level_index + 1)


func _on_restart_pressed():
	get_tree().paused = false
	SceneChanger.load_level(Gamestate.current_level_index)


func _on_quit_pressed():
	get_tree().paused = false
	SceneChanger.change_scene(Resources.main_screen_scene)
