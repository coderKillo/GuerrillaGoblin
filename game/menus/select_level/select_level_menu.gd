extends Control


func _ready():
	for level_index in range(len(Resources.levels)):
		var button := Resources.animated_button_scene.instantiate() as AnimatedButton
		button.pressed.connect(_on_level_pressed.bind(level_index))
		button.label_text = str(level_index + 1)

		%LevelContainer.add_child(button)


func _on_level_pressed(level_number: int) -> void:
	SceneChanger.load_level(level_number)
