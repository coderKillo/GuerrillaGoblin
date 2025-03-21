@tool
extends BTAction


func _generate_name() -> String:
	return "attack"


func _enter():
	agent.attack = true
	agent.movement_component.speed = 0.0


func _tick(_delta) -> Status:
	if not agent.weapon.is_attacking():
		return SUCCESS

	return RUNNING
