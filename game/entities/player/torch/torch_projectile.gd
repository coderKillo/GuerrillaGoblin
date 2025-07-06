@tool
class_name TorchPrjectile
extends Entity25D

@onready var _fire_animation: AnimatedSprite2D = $Model2D/Fire
@onready var _fire_emitter: FireEmitter = $RigidBody3D/FireEmitter
@onready var _rigidbody: RigidBody3D = $RigidBody3D


func _process_25d(_delta):
	if _fire_emitter.charges() > 0:
		_fire_animation.show()
	else:
		_fire_animation.hide()

	if _rigidbody.linear_velocity.x > 0.0:
		model_2d.flip_h = false
	elif _rigidbody.linear_velocity.x < 0.0:
		model_2d.flip_h = true


func setup(charges: int):
	_fire_emitter.add_charges(charges)
	_fire_emitter.call_deferred("disabled", false)


func emitter() -> FireEmitter:
	return _fire_emitter
