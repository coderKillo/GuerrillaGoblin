extends Node2D

var explosion_force = Settings.barrel_explosion_force

@onready var ExplosionScene := preload("res://game/objects/explosion.tscn") as PackedScene

var _destroied = false
var _hits = 0
var _task_text := "destroy tower"


func _ready():
	Events.game_state_changed.connect(_on_game_state_changed)


func _on_game_state_changed(state: Global.GameState):
	match state:
		Global.GameState.INIT:
			Events.task_register.emit(_task_text)

		_:
			pass


func hit(count: int = 1) -> void:
	if _destroied:
		return

	Effects.sprite_bounce(self)

	_hits += count

	match _hits:
		3:
			_destroy()


func _destroy() -> void:
	Events.task_complete.emit(_task_text)

	_destroied = true

	var explosion := ExplosionScene.instantiate()
	explosion.global_position = global_position
	explosion.explosion_force = explosion_force

	get_parent().add_child(explosion)

	queue_free()
