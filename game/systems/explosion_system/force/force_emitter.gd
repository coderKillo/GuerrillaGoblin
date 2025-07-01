class_name ForceEmitter
extends Area3D

@export var force: int = 10
@export var deadzone: float = 0
@export var exclude_detectors: Array[ForceDetector]

@export_group("Debug")
@export var debug := false
@export var debug_name := "no defined name"
@onready var logger := Logger.create(debug_name, debug)


func _ready():
	monitoring = true
	monitorable = false
	collision_layer = 0x0
	collision_mask = Globals.COLLISION_LAYER.FORCE


func _physics_process(_delta):
	set_physics_process(false)
	await get_tree().physics_frame

	for area in get_overlapping_areas():
		var detector := area as ForceDetector
		if not detector:
			continue
		if detector in exclude_detectors:
			continue

		var direction = global_position.direction_to(detector.global_position)
		direction.y = 0  # 2d direction
		direction = direction.normalized()

		var emitter_position = global_position + (direction * deadzone)
		var detector_position = detector.global_position + (-direction * detector.deadzone)

		var force_vector = emitter_position.direction_to(detector_position) * force
		logger.call("apply %s force to %s" % [force_vector, detector.owner.name])
		detector.apply_force(force_vector)


func disable(value: bool):
	set_physics_process(!value)


func is_disabled() -> bool:
	return !is_physics_processing()
