class_name Task
extends HBoxContainer

@onready var _check_box: CheckBox = $CheckBox
@onready var _text: RichTextLabel = $Text

var amount: int:
	get:
		return amount
	set(value):
		amount = value
		_update_task()

var text: String:
	get:
		return text
	set(value):
		text = value
		_update_task()


func _update_task() -> void:
	if amount > 1:
		_check_box.button_pressed = false
		_text.text = str(amount) + " " + text
	elif amount == 1:
		_check_box.button_pressed = false
		_text.text = text
	else:
		_check_box.button_pressed = true
		_text.text = "[s]" + text
