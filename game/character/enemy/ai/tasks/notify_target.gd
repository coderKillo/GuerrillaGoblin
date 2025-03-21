@tool
extends BTAction

enum Mode { GOTO, HELP, MESSAGE }

@export var mode := Mode.GOTO
@export var group := ""
@export var message := ""
@export var message_var := &"target_position"
@export var radius := 300.0


func _generate_name() -> String:
	var group_string = ("Group:" + group) if group else ""
	match mode:
		Mode.GOTO:
			return (
				"ask %s in radius:%.1f to go to %s"
				% [group_string, radius, LimboUtility.decorate_output_var(message_var)]
			)

		Mode.HELP:
			return "ask %s in radius:%.1f for help" % [group_string, radius]

		Mode.MESSAGE:
			return "message:%s to %s in radius:%.1f" % [message, group_string, radius]

		_:
			return "INVALID MDOE!"


func _tick(_delta) -> Status:
	match mode:
		Mode.GOTO:
			var sound = "GOTO:%s" % blackboard.get_var(message_var)
			Effects.spawn_sound(agent.global_position, radius, sound, group)

		Mode.HELP:
			pass

		Mode.MESSAGE:
			Effects.spawn_sound(agent.global_position, radius, message)

		_:
			pass

	return SUCCESS
