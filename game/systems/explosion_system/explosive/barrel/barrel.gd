@tool
extends Entity25D

@onready var _fire_detector: FireDetector = $FireDetector


func _ready_25d():
	_fire_detector.fire_consumed.connect(_on_fire_consumed)


func _on_fire_consumed():
	print("fire")
