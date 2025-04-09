extends Control

@export var button_scene: PackedScene

@onready var _container: Control = %LevelContainer


func _ready():
	for level_index in range(len(Resources.levels)):
		var button := button_scene.instantiate() as Button
		button.pressed.connect(_on_level_pressed.bind(level_index))
		var label := button.get_node("Content/Label") as Label
		label.text = str(level_index + 1)

		_container.add_child(button)


func _on_level_pressed(level_number: int) -> void:
	SceneChanger.load_level(level_number)
