class_name MovementComponent
extends Node2D

@export var movement_speed := 300.0
@export var character: CharacterBody2D
@export var agent: NavigationAgent2D
@export var min_distance := 5

var direction := Vector2.ZERO:
	set(value):
		character.direction = value
	get:
		return character.direction

var speed := 1.0:
	set(value):
		character.movement_speed = movement_speed * value

var target_position := Vector2.ZERO:
	set(value):
		agent.target_position = value
	get:
		return agent.target


func move_to_target():
	direction = global_position.direction_to(agent.get_next_path_position())


func move_to(pos: Vector2):
	agent.target_position = pos
	direction = global_position.direction_to(agent.get_next_path_position())


func is_close_to_target() -> bool:
	return global_position.distance_to(agent.target_position) < min_distance
