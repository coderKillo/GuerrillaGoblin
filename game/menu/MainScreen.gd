extends Control

@export var play_scene: PackedScene

@onready var _play_button: Button = %Play
@onready var _exit_button: Button = %Exit


func _ready():
	_play_button.pressed.connect(_on_play_button_pressed)
	_exit_button.pressed.connect(_on_exit_button_pressed)


func _on_play_button_pressed():
	SceneChanger.change_scene(play_scene)


func _on_exit_button_pressed():
	get_tree().quit()
