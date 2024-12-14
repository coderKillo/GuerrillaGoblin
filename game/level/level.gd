extends Node2D

@onready var _death_area: Area3D = $DeathArea


func _ready():
	_death_area.body_entered.connect(_on_death_area_body_entered)


func _on_death_area_body_entered(body):
	if body.owner.is_in_group("player"):
		get_tree().reload_current_scene()
