extends Weapon

@export var enable_duration := 0.3
@export var delay_duration := 0.4
@export var emitter: FireEmitter
@export var detector: FireDetector
@export var fire_animation: AnimatedSprite2D
@export var throw_component: ThrowComponent


func _ready():
	assert(throw_component)
	emitter.disabled(true)

	throw_component.object_thrown.connect(_on_object_thrown)
	detector.ignited.connect(_on_ignited)


func trigger():
	if emitter.charges() <= 0:
		return

	await get_tree().create_timer(delay_duration).timeout
	emitter.call_deferred("disabled", false)
	await get_tree().create_timer(enable_duration).timeout
	emitter.call_deferred("disabled", true)


func _process(_delta):
	var position_2d = Math.to_2d(global_position).position
	var mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()

	rotation.y = -position_2d.angle_to_point(mouse_position)

	fire_animation.visible = emitter.charges() > 0


func _on_object_thrown(torch: TorchPrjectile):
	if not torch:
		return

	detector.exclude_emitter.append(torch.emitter())

	if emitter.charges() > 0:
		torch.setup(1)
		emitter.add_charges(-1)
	else:
		torch.setup(0)


func _on_ignited():
	print("gi")
	emitter.add_charges(1)
