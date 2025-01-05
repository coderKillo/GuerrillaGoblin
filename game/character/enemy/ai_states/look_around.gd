extends State

@export var after_look_around: State
@export var seen_target: State

@export var look_around_time := 2.0

var _look_around_timer := look_around_time


func enter():
	movement_component.speed = 0.0
	_look_around_timer = look_around_time


func process_state(delta):
	movement_component.character.modulate = Color.YELLOW

	_look_around_timer -= delta
	if _look_around_timer <= 0.0:
		return after_look_around

	if target_component.is_target_seen(movement_component.movement_direction()):
		return seen_target

	return null
