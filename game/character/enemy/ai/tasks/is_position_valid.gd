@tool
extends BTCondition

@export var position := &"target_position"


func _generate_name() -> String:
	return "is %s valid" % LimboUtility.decorate_var(position)


func _tick(_delta) -> Status:
	if blackboard.get_var(position) != Vector2.ZERO:
		return SUCCESS
	return FAILURE
