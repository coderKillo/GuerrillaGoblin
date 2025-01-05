class_name Statemachine
extends Node2D

@export_group("Component")
@export var target_component: TargetComponent
@export var movement_component: MovementComponent
@export var listener_component: ListenerComponent

@export_group("States")
@export var start_state: State

var _current_state: State


func _ready():
	for child in get_children():
		child.target_component = target_component
		child.movement_component = movement_component
		child.listener_component = listener_component

	_change_state(start_state)


func _process(delta):
	var new_state = _current_state.process_state(delta)
	if new_state:
		_change_state(new_state)


func _physics_process(delta):
	var new_state = _current_state.physics_process_state(delta)
	if new_state:
		_change_state(new_state)


func _unhandled_input(event):
	var new_state = _current_state.unhandled_input_state(event)
	if new_state:
		_change_state(new_state)


func _change_state(state: State):
	if _current_state:
		_current_state.exit()

	_current_state = state
	_current_state.enter()
