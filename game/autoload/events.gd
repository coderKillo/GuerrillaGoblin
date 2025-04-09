extends Node

signal game_state_changed(state: Global.GameState)

signal task_register(text: String)
signal task_complete(text: String)

signal player_death

signal enemy_death(name: String)
signal enemy_seen_player(name: String)

signal cutscene_finished
