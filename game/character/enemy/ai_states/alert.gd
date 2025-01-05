extends State

@export var after_alert_time: State
@export var alert_time := 1.0

var _alert_timer = alert_time


func enter():
	movement_component.speed = 0.0
	movement_component.move_to(target_component.last_target_position)


func process_state(delta):
	_alert_timer -= delta

	movement_component.character.modulate = Color.YELLOW

	if _alert_timer <= 0.0:
		return after_alert_time

	return null
