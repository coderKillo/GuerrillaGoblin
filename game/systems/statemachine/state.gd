class_name State
extends Node2D

var target_component: TargetComponent
var movement_component: MovementComponent
var listener_component: ListenerComponent


func enter():
	pass


func exit():
	pass


func process_state(_delta: float) -> State:
	return null


func physics_process_state(_delta: float) -> State:
	return null


func unhandled_input_state(_event: InputEvent) -> State:
	return null
