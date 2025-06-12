class_name GameGui
extends CanvasLayer

enum Screens { HUD, PAUSE, WIN, DEATH }

@onready var screens = {
	Screens.PAUSE: $PauseScreen,
	Screens.WIN: $WinScreen,
	Screens.DEATH: $DeathScreen,
}


func _ready():
	screens[Screens.PAUSE].continue_pressed.connect(_on_continue_pressed)


func _unhandled_input(event):
	if event.is_action_pressed("pause_game"):
		toggle_pause()


func toggle_pause() -> void:
	if screens[Screens.PAUSE].visible:
		_set_sceen(Screens.HUD)
	else:
		_set_sceen(Screens.PAUSE)


func win_screen(time_s: int, score: int):
	screens[Screens.WIN].setup(time_s, score)
	_set_sceen(Screens.WIN)


func death_screen():
	_set_sceen(Screens.DEATH)


func _on_continue_pressed() -> void:
	_set_sceen(Screens.HUD)


func _set_sceen(active_screen: Screens):
	for screen in screens:
		if screen == active_screen:
			screens[screen].show()
		else:
			screens[screen].hide()
