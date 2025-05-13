extends Area3D

@export var explosion_force = 20.0
@export var radius = 0.5

@onready var _spirte := $Sprite3D as Sprite3D
@onready var _collision_shape := $CollisionShape3D as CollisionShape3D


func _ready():
	_spirte.scale = Vector3.ONE * (radius / 0.5)
	_collision_shape.shape.radius = radius


func _physics_process(_delta):
	await get_tree().physics_frame

	set_physics_process(false)

	for body in get_overlapping_bodies():
		var xz_force = body.global_position - global_position
		var y_force = radius / xz_force.length()
		var force = Vector3(xz_force.x, y_force, xz_force.z).normalized() * explosion_force
		if body is CharacterBody3D:
			body.added_velocity += force
		elif body is RigidBody3D:
			body.apply_central_impulse(force)

		if body.has_method("burn"):
			body.burn()
		if body.owner and body.owner.has_method("burn"):
			body.owner.burn()

		if body.has_method("hit"):
			body.hit()
		if body.owner and body.owner.has_method("hit"):
			body.owner.hit()

	await get_tree().create_timer(1.0).timeout

	queue_free()
