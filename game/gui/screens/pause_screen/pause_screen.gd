extends Control

signal continue_pressed


func _ready():
	%Continue.pressed.connect(_on_continue_pressed)
	%Quit.pressed.connect(_on_quit_pressed)

	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_continue_pressed():
	get_tree().paused = false
	continue_pressed.emit()


func _on_quit_pressed():
	get_tree().paused = false
	SceneChanger.change_scene(Resources.main_screen_scene)
