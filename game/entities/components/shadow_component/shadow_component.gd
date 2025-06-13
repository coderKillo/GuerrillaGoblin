extends Node

const SHADOW_VISIBLE_DISTANCE = 5

@export var model2d: Model2D
@export var body3d: Node3D

@onready var shadow_sprite: Sprite2D = $ShadowSprite


func _ready():
	assert(model2d)
	assert(body3d)


func _physics_process(_delta):
	shadow_sprite.global_position = model2d.global_position

	var ground_vector = body3d.global_position - _get_ground_position()
	var scale_factor = 1 - ground_vector.y / SHADOW_VISIBLE_DISTANCE
	print(scale_factor)

	shadow_sprite.offset.y = (
		(-body3d.global_position.y + ground_vector.y) * Globals.SCALE * Globals.BASE_VECTOR.y
	)

	if scale_factor >= 0 and scale_factor <= 1.02:
		shadow_sprite.scale = Vector2.ONE * scale_factor
		shadow_sprite.show()
	else:
		shadow_sprite.hide()


func _get_ground_position() -> Vector3:
	var start = body3d.global_position + Vector3(0, 0.05, 0)
	var end = start + (Vector3.DOWN * SHADOW_VISIBLE_DISTANCE)
	var query = PhysicsRayQueryParameters3D.create(start, end)
	query.collision_mask = Globals.COLLISION_LAYER.GROUND

	var result = body3d.get_world_3d().direct_space_state.intersect_ray(query)

	if result:
		return result.position
	else:
		return end
