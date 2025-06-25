class_name FireDetector
extends Node

signal fire_consumed

@export var _area: Area3D
@export var _scan_interval: float = 0.5

var _scan_timer: float
var _ignore_areas: Array[EmitterArea]


func _ready():
	assert(_area)

	_area.area_entered.connect(_on_area_entered)

	_scan_timer = _scan_interval


func _physics_process(delta):
	_scan_timer -= delta
	if _scan_timer > 0.0:
		return

	_scan_timer = _scan_interval

	for area in _area.get_overlapping_areas():
		if area in _ignore_areas:
			return
		var emitter := area as EmitterArea
		if not emitter:
			return
		emitter.body_collided += 1
		fire_consumed.emit()
		break

	_ignore_areas.clear()


func _on_area_entered(area: Area3D):
	var emitter := area as EmitterArea
	if not emitter:
		return

	emitter.body_collided += 1
	_ignore_areas.append(area)
	fire_consumed.emit()
