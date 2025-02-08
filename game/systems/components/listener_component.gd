class_name ListenerComponent
extends Node2D

@export var sound_radius := 100.0
@export var reset_sound_time := 0.5

var sound_position := Vector2.ZERO
var sound_string := ""

var _reset_sound_timer := 0.0


func create_sound(sound: String):
	Effects.spawn_sound(global_position, sound_radius, sound)


func on_hear_sound(sound: String, pos: Vector2):
	sound_position = pos
	sound_string = sound
	_reset_sound_timer = reset_sound_time


func _process(delta):
	if _reset_sound_timer > 0.0:
		_reset_sound_timer -= delta


func has_sound_heard() -> bool:
	return _reset_sound_timer > 0.0
