extends State

@export var next_state: State
@export var radius: float = 300.0


func process_state(_delta):
	Effects.spawn_sound(global_position, radius, "GOTO:%s" % target_component.target_position)
	return next_state
