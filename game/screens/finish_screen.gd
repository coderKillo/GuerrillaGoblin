extends Control

var main_menu: String = "res://game/menu/main_sceen.tscn"


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
	pass


func _on_restart_pressed():
	pass


func _on_quit_pressed():
	SceneChanger.change_scene(load(main_menu))
