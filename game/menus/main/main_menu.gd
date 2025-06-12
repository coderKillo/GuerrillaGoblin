extends Control

const MAIN_POSITION := Vector2(640, 360)
const SETTINGS_POSITION := Vector2(1920, 360)


func _ready():
	%Play.pressed.connect(_on_play_button_pressed)
	%Setting.pressed.connect(_on_setting_button_pressed)
	%Exit.pressed.connect(_on_exit_button_pressed)

	%Back.pressed.connect(_on_back_button_pressed)


func _on_play_button_pressed():
	SceneChanger.change_scene(Resources.select_level_scene)


func _on_setting_button_pressed():
	$Camera2D.global_position = SETTINGS_POSITION


func _on_exit_button_pressed():
	get_tree().quit()


func _on_back_button_pressed():
	$Camera2D.global_position = MAIN_POSITION
