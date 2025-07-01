class_name ForceDetector
extends Area3D

signal force_detected(Vector3)

@export var deadzone: float = 0
@export var apply_force_to: Node

@export_group("Debug")
@export var debug := false
@export var debug_name := "no defined name"
@onready var logger := Logger.create(debug_name, debug)


func _ready():
	monitoring = false
	monitorable = true
	collision_layer = Globals.COLLISION_LAYER.FORCE
	collision_mask = 0x0


func apply_force(force: Vector3):
	force_detected.emit(force)

	logger.call("receive force %s" % force)

	if apply_force_to is MovementComponent:
		apply_force_to.added_velocity += force

	if apply_force_to is RigidBody3D:
		apply_force_to.apply_impulse(force)
