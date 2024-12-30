extends State

@export var after_attack: State
@export var attack_range: float = 50.0


func enter():
	if global_position.distance_to(target_component.target_position) < attack_range:
		movement_component.character.attack = true


func process_state(_delta):
	if not movement_component.character.attack:
		return after_attack

	return null
