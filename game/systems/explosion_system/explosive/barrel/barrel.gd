@tool
extends Entity25D

@export var _fire_detector: FireDetector


func _ready_25d():
	_fire_detector.ignited.connect(_on_ignited)


func _on_ignited():
	print("fire")
