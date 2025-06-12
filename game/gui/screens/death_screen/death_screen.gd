extends Control


func _ready():
	%Restart.pressed.connect(_on_restart_pressed)
	%Quit.pressed.connect(_on_quit_pressed)

	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_restart_pressed():
	get_tree().paused = false
	SceneChanger.load_level(GameState.current_level_index)


func _on_quit_pressed():
	get_tree().paused = false
	SceneChanger.change_scene(Resources.main_screen_scene)
