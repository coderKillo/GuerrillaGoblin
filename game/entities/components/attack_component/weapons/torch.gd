extends Weapon

@export var enable_duration := 0.5

@onready var _emitter: FireEmitter = $FireEmitter

var fire_stacks := 1


func _ready():
	_emitter.disabled(true)


func trigger():
	if _emitter.fire_stack() <= 0:
		print("out")
		return
	print("on")

	_emitter.call_deferred("disabled", false)
	await get_tree().create_timer(enable_duration).timeout
	_emitter.call_deferred("disabled", true)


func _process(_delta):
	var position_2d = Math.to_2d(global_position).position
	var mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()

	rotation.y = -position_2d.angle_to_point(mouse_position)
