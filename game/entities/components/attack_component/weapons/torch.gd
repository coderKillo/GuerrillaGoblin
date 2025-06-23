extends Weapon

@export var enable_duration := 0.5

#@onready var _area: Area3D = $Area3D
@onready var _shape: CollisionShape3D = $Area3D/CollisionShape3D


func _ready():
	_shape.disabled = true


func trigger():
	_shape.set_deferred("disabled", false)
	await get_tree().create_timer(enable_duration).timeout
	_shape.set_deferred("disabled", true)


func _process(_delta):
	var position_2d = Math.to_2d(global_position).position
	var mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()

	rotation.y = -position_2d.angle_to_point(mouse_position)
