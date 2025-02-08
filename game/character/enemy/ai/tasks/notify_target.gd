extends BTAction

enum Mode { GOTO, HELP, MESSAGE }

@export var mode := Mode.GOTO
@export var message := ""
@export var message_var := &"target_position"
@export var radius := 300.0


func _tick(_delta) -> Status:
	match mode:
		Mode.GOTO:
			var sound = "GOTO:%s" % blackboard.get_var(message_var)
			Effects.spawn_sound(agent.global_position, radius, sound)

		Mode.HELP:
			pass

		Mode.MESSAGE:
			Effects.spawn_sound(agent.global_position, radius, message)

		_:
			pass

	return SUCCESS
