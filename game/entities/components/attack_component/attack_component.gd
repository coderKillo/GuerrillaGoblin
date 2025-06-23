class_name AttackComponent
extends Node

signal attacking

@export var weapon: Weapon

var is_attacking: bool


func attack() -> void:
	if not weapon:
		return

	if is_attacking:
		return

	attacking.emit()

	is_attacking = true
	weapon.trigger()
	await get_tree().create_timer(weapon.cooldown).timeout
	is_attacking = false
