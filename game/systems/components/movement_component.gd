class_name MovementComponent
extends Node2D

@export var movement_speed := 300.0
@export var character: CharacterBody2D
@export var agent: NavigationAgent2D
@export var min_distance := 5

var speed := 1.0:
	set(value):
		character.movement_speed = movement_speed * value


func _process(_delta):
	if is_close_to_target():
		return
	character.direction = global_position.direction_to(agent.get_next_path_position())


func move(direction: Vector2):
	character.direction = direction


func movement_direction() -> Vector2:
	return character.direction


func move_to(pos: Vector2):
	agent.target_position = pos


func is_close_to_target() -> bool:
	return global_position.distance_to(agent.target_position) < min_distance
