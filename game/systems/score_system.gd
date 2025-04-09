class_name ScoreSystem
extends Node

var _data: Dictionary = {enemies_seen_player = []}


func _ready():
	Events.enemy_death.connect(_on_enemy_death)
	Events.enemy_seen_player.connect(_on_enemy_seen_player)


func _on_enemy_death(enemy_name: String) -> void:
	_data.enemies_seen_player.remove(enemy_name)


func _on_enemy_seen_player(enemy_name: String) -> void:
	if enemy_name in _data.enemies_seen_player:
		return

	_data.enemies_seen_player.append(enemy_name)


func calculate_score(time_s: int) -> int:
	var score = 0

	score += time_s

	var player_unseen = _data.enemies_seen_player.is_empty()
	if player_unseen:
		score *= 2

	return score
