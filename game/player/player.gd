extends CharacterBody3D

const SPEED = 5.0
const AIR_MOVEMENT_FACTOR = 0.04
const PUSH_FORCE = 1.0

enum Weapon { TORCH, BARREL, TNT }
@export var weapon: Weapon

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction := Vector3.ZERO
var added_velocity := Vector3.ZERO

var _is_burning := false
var _timer := 0.0
var _cooldown := 0.0

@onready var _weapon_node = $Weapon
@onready var _sprite = $Sprite3D
@onready var _mesh = $MeshInstance3D2
@onready var _shadow = $MeshInstance3D


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if not is_on_floor():
		velocity.x = move_toward(velocity.x, direction.x * SPEED, AIR_MOVEMENT_FACTOR)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, AIR_MOVEMENT_FACTOR)
	elif direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	velocity += added_velocity
	added_velocity = Vector3.ZERO

	move_and_slide()

	_shadow.global_position.y = 0

	if global_position.y < -1:
		queue_free()


func _process(delta):
	if _cooldown > 0.0:
		_cooldown -= delta

	match weapon:
		Weapon.TORCH:
			pass

		Weapon.BARREL:
			if not _is_burning:
				_timer = 2.0
				return

			_timer -= delta
			if _timer < 0.0:
				_cooldown = 0.5

				var explsion = Resources.ExplosionScene.instantiate()
				explsion.explosion_force = 10.0
				explsion.radius = 3
				get_parent().add_child(explsion)

				explsion.global_position = global_position - (velocity * delta)
				global_position = _weapon_node.global_position

				_is_burning = false
				_mesh.hide()
				_sprite.modulate = Color.WHITE

		Weapon.TNT:
			pass

		_:
			pass


func attack(target: Vector3):
	var target_on_same_plane = Vector3(target.x, global_position.y, target.z)
	var distance = global_position.distance_to(target_on_same_plane)
	match weapon:
		Weapon.TORCH:
			if not _is_burning:
				return

			if distance > 7.0:
				return

			var object = Resources.FlamableScene.instantiate()
			object.burn_tick_time = 0.1
			object.burn_radius = 0.4
			get_parent().add_child(object)

			if distance > 1.0:
				_is_burning = false
				_sprite.modulate = Color.WHITE

				object.burn_time = 1.3

				var force = _calculate_launch_velocity(_weapon_node.global_position, target, 1.0)
				object.global_position = _weapon_node.global_position
				object.global_position += _weapon_node.global_position.direction_to(target) * 0.5
				object.apply_central_impulse(force)
			else:
				object.burn_time = 0.3
				object.global_position = target

		Weapon.BARREL:
			pass

		Weapon.TNT:
			if _cooldown > 0.0:
				return
			if distance > 7.0:
				return
			_cooldown = 1.0

			var object = Resources.ExplosiveScene.instantiate()
			get_parent().add_child(object)

			if _is_burning:
				object.burn()
				_is_burning = false
				_sprite.modulate = Color.WHITE

			var force = _calculate_launch_velocity(_weapon_node.global_position, target, 1.0)
			object.global_position = _weapon_node.global_position
			object.apply_central_impulse(force)

		_:
			pass


func burn():
	match weapon:
		Weapon.TORCH:
			_is_burning = true
			_sprite.modulate = Color.RED

		Weapon.BARREL:
			if _cooldown > 0.0:
				return

			_is_burning = true
			_mesh.show()
			_sprite.modulate = Color.RED

		Weapon.TNT:
			_is_burning = true
			_sprite.modulate = Color.RED

		_:
			pass


func _calculate_launch_velocity(
	start_pos: Vector3, target_pos: Vector3, flight_time: float
) -> Vector3:
	var displacement := target_pos - start_pos

	return Vector3(
		displacement.x / flight_time,
		(displacement.y / flight_time) + 0.5 * gravity * flight_time,
		displacement.z / flight_time
	)
