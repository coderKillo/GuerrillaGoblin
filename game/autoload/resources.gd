extends Node

var main_game_scene: PackedScene = preload("res://game/world/base/main_scene.tscn")
var main_screen_scene: PackedScene = preload("res://game/menus/main/main_menu.tscn")
var levels: Array[PackedScene] = [preload("res://game/world/levels/test_level.tscn")]
