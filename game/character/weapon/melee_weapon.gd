extends Node2D

signal weapon_done

@export var area: Area2D
@export var anticipation_time: float = 0.2
@export var anticipation_angle: float = -30.0
@export var strike_angle: float = 100.0
@export var strike_time: float = 0.1
@export var recover_time: float = 0.1

var _is_attacking := false


func _ready():
	area.body_entered.connect(weapon_body_entered)


func is_attacking():
	return _is_attacking


func attack():
	if _is_attacking:
		return

	_is_attacking = true

	var tween := get_tree().create_tween()
	var angle = rotation_degrees

	tween.tween_property(self, "rotation_degrees", angle + anticipation_angle, anticipation_time)
	tween.tween_property(self, "rotation_degrees", angle + strike_angle, strike_time)
	tween.tween_property(self, "rotation_degrees", angle, recover_time)

	await tween.finished

	_is_attacking = false

	weapon_done.emit()


func weapon_body_entered(body):
	if body.has_method("hit"):
		body.hit()
