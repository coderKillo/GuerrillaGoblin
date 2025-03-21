class_name MovementComponent
extends Node2D

@export var movement_speed := Settings.base_movement_speed
@export var character: CharacterBody2D
@export var agent: NavigationAgent2D
@export var min_distance := 50
@export var new_path_query_tolerance := 40

@onready var air_component: AirComponent = $"../AirComponent"

var ignore_navigation := false  # keep velocity regarding of navigation

var speed := 1.0
var wanted_velocity := Vector2.ZERO


func _ready():
	assert(air_component, "please add AirComponent as sibling")
	agent.velocity_computed.connect(_on_velocity_computed)


func _on_velocity_computed(safe_velocity: Vector2):
	if air_component.is_in_air():
		character.velocity = air_component.air_velocity
	else:
		character.velocity = safe_velocity

	character.move_and_slide()


func _physics_process(_delta):
	if is_close_to_target():
		wanted_velocity = Vector2.ZERO

	elif agent.is_navigation_finished():
		wanted_velocity = Vector2.ZERO

	else:
		var next_position := agent.get_next_path_position()
		wanted_velocity = global_position.direction_to(next_position) * movement_speed * speed

	agent.set_velocity(wanted_velocity)


func stop():
	wanted_velocity = Vector2.ZERO


func movement_direction() -> Vector2:
	return character.velocity.normalized()


func move_to(pos: Vector2):
	if (
		agent.target_position != Vector2.ZERO
		and agent.target_position.distance_to(pos) < new_path_query_tolerance
	):
		return
	agent.target_position = pos


func is_close_to_target() -> bool:
	return global_position.distance_to(agent.target_position) < min_distance
