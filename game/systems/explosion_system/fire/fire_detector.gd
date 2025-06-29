class_name FireDetector
extends Area3D

signal ignited

## Time how long the area is disabled after detecting an emitter.
## If the time is 0, then the area will stay disabled.
@export var disable_time_after_ignition := 0.0
@export var is_ignited = false

@onready var _shape: CollisionShape3D = $CollisionShape3D


func _ready():
	monitoring = true
	monitorable = false
	collision_layer = 0x0
	collision_mask = Globals.COLLISION_LAYER.FIRE
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area3D):
	if is_ignited:
		return
	var emitter := area as FireEmitter
	if not emitter:
		return

	emitter.has_ignited = true
	ignited.emit()
	is_ignited = true

	_shape.set_deferred("disabled", true)
	if disable_time_after_ignition > 0.0:
		await get_tree().create_timer(disable_time_after_ignition).timeout
		_shape.set_deferred("disabled", false)


func reset():
	_shape.set_deferred("disabled", false)
	is_ignited = false
