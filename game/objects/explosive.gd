extends RigidBody3D

@export var explosion_radius := 0.5
@export var explosion_force := 20.0

var timer := 2.0

@onready var _sprite = $Sprite3D as Sprite3D
@onready var _mesh = $MeshInstance3D as MeshInstance3D

var _is_burning := false


func _ready():
	_mesh.hide()
	_mesh.mesh.top_radius = explosion_radius
	_mesh.mesh.bottom_radius = explosion_radius


func _process(delta):
	# _draw_trajectory(Color.GREEN, 0.0)
	if not _is_burning:
		return

	timer -= delta
	if timer < 0.0:
		var explsion = Resources.ExplosionScene.instantiate()
		explsion.explosion_force = explosion_force
		explsion.radius = explosion_radius
		get_parent().add_child(explsion)
		explsion.global_position = global_position
		queue_free()


func burn():
	_is_burning = true
	_sprite.modulate = Color.RED
	_mesh.show()


func _draw_trajectory(color, time):
	for player in get_tree().get_nodes_in_group("player"):
		var start_pos = player.global_position
		var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		var xz_force = player.global_position - global_position
		var y_force = explosion_radius / xz_force.length()
		var vel = Vector3(xz_force.x, y_force, xz_force.z).normalized() * explosion_force

		var t = 2 * vel.y / gravity
		var end = start_pos + (vel * t)
		start_pos.y = 0.1
		end.y = 0.1
		Drawline3d.DrawLine(start_pos, end, color, time)

		break
