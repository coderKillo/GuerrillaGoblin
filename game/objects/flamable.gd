extends RigidBody3D

@export var burn_time := 3.0
@export var burn_tick_time := 1.0
@export var burn_radius := 1.0
@export var infinit_flame := false

@onready var _area := $Area3D as Area3D
@onready var _collision_shape := $Area3D/CollisionShape3D as CollisionShape3D
@onready var _sprite := $Sprite3D as Sprite3D


func _ready():
	_collision_shape.shape.radius = burn_radius
	_sprite.scale = Vector3.ONE * burn_radius


func _physics_process(delta):
	await get_tree().physics_frame

	burn_time -= delta
	burn_tick_time -= delta

	if burn_tick_time <= 0.0:
		_burn()
		burn_tick_time = 1.0

	if burn_time <= 0.0 and not infinit_flame:
		queue_free()


func _burn():
	for body in _area.get_overlapping_bodies():
		if body.has_method("burn"):
			body.burn()
		if body.owner and body.owner.has_method("burn"):
			body.owner.burn()
