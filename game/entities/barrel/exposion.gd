extends Entity2D

@export var explosion_force = 20.0

@onready var _animation: AnimatedSprite2D = $Model2D/Animation

var radius := 0.5
var area: Area3D


func _ready_25d():
	assert(object_3d is Area3D, "object 3d has to be a Area3D")

	area = object_3d
	radius = area.shape_owner_get_shape(0, 0).radius

	_animation.animation_finished.connect(_on_animation_finished)


func _physics_process(_delta):
	await get_tree().physics_frame

	for body in area.get_overlapping_bodies():
		var force_direction = (
			body.global_position - object_3d.global_position + (Vector3.UP * radius / 2.0)
		)
		var force = force_direction.normalized() * explosion_force

		if body is CharacterBody3D:
			body.velocity += force
		elif body is RigidBody3D:
			body.apply_central_impulse(force)

		if body.owner.has_method("hit"):
			body.owner.hit()

	# only called once
	set_physics_process(false)


func _on_animation_finished():
	queue_free()
