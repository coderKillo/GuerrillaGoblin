@tool
extends BTAction

@export var duration := 2.0
@export var turns := 4

var _turns_left := 0
var _turns_time := 0.0


func _generate_name() -> String:
	return "look around for %.1fs" % duration


func _enter():
	agent.movement_component.stop()
	_turns_left = turns
	_turns_time = duration / float(turns)


func _tick(delta) -> Status:
	_turns_time -= delta
	if _turns_time <= 0.0:
		_turn()
		_turns_time = duration / float(turns)
		_turns_left -= 1

	if _turns_left <= 0:
		return SUCCESS

	return RUNNING


func _turn():
	agent.direction *= -1.0
