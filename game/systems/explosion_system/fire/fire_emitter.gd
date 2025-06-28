class_name FireEmitter
extends Area3D

@export var _initial_chages: int = 0

@onready var _shape: CollisionShape3D = $CollisionShape3D

var has_ignited := false

var _ignition_charges := 0
var _ignition_timer := 0.0


func _ready():
	assert(_shape)

	monitoring = true
	monitorable = true
	_ignition_charges = _initial_chages


func _physics_process(delta):
	if _ignition_charges <= 0:
		return

	if _ignition_timer > 0.0:
		return
	_ignition_timer -= delta

	if has_ignited:
		has_ignited = false
		_ignition_charges -= 1
		_ignition_timer = Globals.IGNITION_CHARGE_INTERVAL


func disabled(value: bool):
	_ignition_timer = 0.0
	_shape.disabled = value
	set_process(!value)


func add_charges(value: int = 1):
	_ignition_charges += value


func charges() -> int:
	return _ignition_charges
