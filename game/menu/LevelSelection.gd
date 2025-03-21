extends Control

@export var button_scene: PackedScene
@export var level_list: Array[PackedScene]

@onready var _container: Control = %LevelContainer


func _ready():
	var level_number = 1
	for level in level_list:
		var button := button_scene.instantiate() as Button
		button.pressed.connect(_on_level_pressed.bind(level))
		var label := button.get_node("Content/Label") as Label
		label.text = str(level_number)

		_container.add_child(button)

		level_number += 1


func _on_level_pressed(level: PackedScene) -> void:
	print(level)
