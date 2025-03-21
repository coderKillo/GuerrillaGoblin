@tool
extends BTAction

@export var position := &"target_position"


func _generate_name() -> String:
	return "reset %s" % LimboUtility.decorate_var(position)


func _tick(_delta) -> Status:
	blackboard.set_var(position, Vector2.ZERO)
	return SUCCESS
