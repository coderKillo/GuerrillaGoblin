extends Area2D

@export var explosion_force := Settings.barrel_explosion_force

@onready var _animation: AnimatedSprite2D = $AnimatedSprite2D

var radius := 0.0


func _ready():
	radius = shape_owner_get_shape(0, 0).radius

	_animation.animation_finished.connect(_on_animation_finished)


func _physics_process(_delta):
	await get_tree().physics_frame

	for body in get_overlapping_bodies():
		var force_direction = global_position.direction_to(body.global_position)
		var distance_factor = global_position.distance_to(body.global_position) / radius
		var force = (
			Vector3(force_direction.x, force_direction.y, 1.0) * explosion_force * distance_factor
		)

		var air_component = body.get_node_or_null("AirComponent") as AirComponent
		if air_component:
			air_component.add_force(force)

		if body.has_method("hit"):
			body.hit(3)

	Effects.spawn_sound(global_position, radius * 10.0, "BANG")

	# only called once
	set_physics_process(false)


func _on_animation_finished():
	queue_free()
