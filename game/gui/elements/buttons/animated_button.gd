@tool
class_name AnimatedButton
extends Button

@export var label_text: String:
	set(value):
		label_text = value
		$Content/Label.text = value

@export_group("animation")
@export_subgroup("scale")
@export var scale_normal := Vector2.ONE
@export var scale_up := Vector2(1.2, 1.2)
@export var scale_pressed := Vector2(0.6, 0.6)

@export_subgroup("rotation")
@export var rotation_normal := 0.0
@export var rotation_pressed := 0.1

@export_subgroup("time")
@export var time := 1.2


func _process(_delta):
	pass
