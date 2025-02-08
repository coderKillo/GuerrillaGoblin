extends Node

@export_group("general")
@export var gravity := 10 * 168

@export_group("character")
@export var base_movement_speed := 500.0
@export var base_health := 10

@export_group("enemy")
@export var run_speed := 1.2
@export var walk_speed := 0.5

@export_group("barrel")
@export var barrel_explosion_force := 2000.0
@export var barrel_explosion_delay := 3.0
