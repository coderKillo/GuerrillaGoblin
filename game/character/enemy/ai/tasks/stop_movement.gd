@tool
extends BTAction


func _tick(_delta) -> Status:
	agent.movement_component.speed = 0.0
	return SUCCESS
