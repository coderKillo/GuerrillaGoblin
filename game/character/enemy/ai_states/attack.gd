extends State

@export var after_attack: State
@export var attack_range: float = 50.0
@export var character: CharacterBody2D


func enter():
	if global_position.distance_to(target_component.last_target_position) < attack_range:
		character.attack = true


func process_state(_delta):
	if not character.attack:
		return after_attack

	return null
