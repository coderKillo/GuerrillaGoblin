extends CharacterBody2D

@export var weapon: Node2D

@export var attack := false
@export var direction := Vector2.ZERO  # view direction

var status := ""

@onready var air_component: AirComponent = $AirComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var target_component: TargetComponent = $TargetComponent
@onready var listener_component: ListenerComponent = $ListenerComponent
@onready var path_component: PathComponent = $PathComponent
@onready var status_label: Label = $StatusLabel


func _physics_process(_delta):
	if attack and weapon:
		weapon.attack()
		attack = false

	if weapon:
		weapon.look_at(global_position + direction)

	if weapon and weapon.is_attacking():
		movement_component.stop()


func _process(_delta):
	update_status()


func update_status():
	match status:
		"?":
			status_label.show()
			status_label.text = "?"
			status_label.modulate = Color.YELLOW

		"!":
			status_label.show()
			status_label.text = "!"
			status_label.modulate = Color.RED

		_:
			status_label.hide()


func hit(_count: int = 1):
	print("enemy hit")
