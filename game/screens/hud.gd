class_name Hud
extends Control

@onready var TaskScene = preload("res://game/screens/task.tscn")

@onready var _tasks: VBoxContainer = %Tasks
@onready var _time: Label = %Time


func set_time(time_s: int) -> void:
	_time.text = Gui.time_to_string(time_s)


func set_tasks(tasks: Dictionary) -> void:
	for child in _tasks.get_children():
		child.queue_free()

	for task_name in tasks:
		var task := TaskScene.instantiate() as Task
		_tasks.add_child(task)
		task.amount = tasks[task_name]
		task.text = task_name


func update_tasks(tasks: Dictionary) -> void:
	for child in _tasks.get_children():
		assert(child is Task)
		assert(child.text in tasks)
		child.amount = tasks[child.text]
