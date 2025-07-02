extends Node

# Menus
var main_screen_scene: PackedScene = preload("res://game/menus/main/main_menu.tscn")
var select_level_scene: PackedScene = preload(
	"res://game/menus/select_level/select_level_menu.tscn"
)

# Level
var main_game_scene: PackedScene = preload("res://game/world/base/main_scene.tscn")
var levels: Array[PackedScene] = [preload("res://game/world/levels/test_level.tscn")]

# GUI Elements
var animated_button_scene: PackedScene = preload(
	"res://game/gui/elements/buttons/animated_button.tscn"
)

# Objects
var explosion_scene: PackedScene = preload(
	"res://game/systems/explosion_system/explosion/explosion.tscn"
)

var barrel_scene: PackedScene = preload(
	"res://game/systems/explosion_system/explosive/barrel/barrel.tscn"
)
