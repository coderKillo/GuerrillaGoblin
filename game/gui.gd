class_name Gui
extends Control

@onready var screens = {hud = $"HUD", pause = $"PauseScreen", finish = $"FinishScreen"}

var _current_screen: Control


static func time_to_string(time_s: int) -> String:
	var hours = int(time_s / 3600.0) % 24
	var minutes = int(time_s / 60.0) % 60
	var seconds = int(time_s) % 60

	if hours > 0:
		return "%02d:%02d:%02d" % [hours, minutes, seconds]
	else:
		return "%02d:%02d" % [minutes, seconds]


func _ready():
	_set_sceen("hud")

	screens.pause.continue_pressed.connect(_on_continue_pressed)


func hud() -> Hud:
	return screens.hud


func _unhandled_input(event):
	if event.is_action_pressed("pause_game"):
		print("toggle_pause")
		toggle_pause()


func toggle_pause() -> void:
	if screens.pause.visible:
		_set_sceen("hud")
	else:
		_set_sceen("pause")


func finish_screen(time_s: int, score: int, success: bool):
	screens.finish.setup(time_s, score, success)
	_set_sceen("finish")


func _on_continue_pressed() -> void:
	_set_sceen("hud")


func _set_sceen(active_screen: String):
	for screen in screens:
		if screen == active_screen:
			_current_screen = screens[screen]
			screens[screen].show()
		else:
			screens[screen].hide()
