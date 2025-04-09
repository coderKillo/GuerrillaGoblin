extends CharacterBody2D

@export var weapon: Node2D

@export var attack := false
@export var direction := Vector2.ZERO  # view direction
@export var view_angle := 60.0  # view direction

var status := ""
var health := Settings.enemy_health

@onready var air_component: AirComponent = $AirComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var target_component: TargetComponent = $TargetComponent
@onready var listener_component: ListenerComponent = $ListenerComponent
@onready var path_component: PathComponent = $PathComponent
@onready var status_label: Label = $StatusLabel
@onready var bt: BTPlayer = $BTPlayer


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
	update_knowlege()


func update_status():
	match status:
		"?":
			status_label.show()
			status_label.text = "?"
			status_label.modulate = Color.YELLOW
			Events.enemy_seen_player.emit(self.name)

		"!":
			status_label.show()
			status_label.text = "!"
			status_label.modulate = Color.RED
			Events.enemy_seen_player.emit(self.name)

		_:
			status_label.hide()


func update_knowlege():
	if target_component.is_target_seen(direction, view_angle):
		bt.blackboard.set_var(&"player_position", target_component.last_target_position)
	else:
		bt.blackboard.set_var(&"player_position", Vector2.ZERO)

	if listener_component.has_sound_heard():
		bt.blackboard.set_var(&"noise_position", listener_component.sound_position)

	var guards := target_component.get_targets_by_distance("guard")
	if guards:
		bt.blackboard.set_var(&"closest_guard", guards[0].global_position)
	else:
		bt.blackboard.set_var(&"closest_guard", Vector2.ZERO)

	var safe_spots := target_component.get_targets_by_distance("safe_spot")
	if safe_spots:
		bt.blackboard.set_var(&"closest_safe_spot", safe_spots[0].global_position)
	else:
		bt.blackboard.set_var(&"closest_safe_spot", Vector2.ZERO)


func hit(count: int = 1):
	health -= count
	if health <= 0:
		Events.enemy_death.emit(self.name)
		queue_free()
