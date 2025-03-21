@tool
extends BTAction

@export var seconds := 2
@export var is_alerted_var := "is_alerted"


func _generate_name() -> String:
	return "%s == false -> delay %ss" % [LimboUtility.decorate_var(is_alerted_var), seconds]


func _exit():
	blackboard.set_var(is_alerted_var, true)


func _tick(_delay) -> Status:
	if blackboard.get_var(is_alerted_var):
		return SUCCESS
	if elapsed_time > seconds:
		return SUCCESS
	return RUNNING
