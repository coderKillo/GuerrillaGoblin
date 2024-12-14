extends RayCast3D

@export var shadow_sprite: Sprite2D

var body: Node3D


func _ready():
	body = get_parent()


func _physics_process(_delta):
	var ground_vector = global_position - get_collision_point()
	var scale_factor = 1 - ground_vector.y / 5

	shadow_sprite.offset.y = (
		(-body.global_position.y + ground_vector.y) * Entity2D.SCALE * Entity2D.BASE_VECTOR.y
	)

	if scale_factor >= 0 and scale_factor <= 1.01:
		shadow_sprite.scale = Vector2.ONE * scale_factor
		shadow_sprite.show()
	else:
		shadow_sprite.hide()
