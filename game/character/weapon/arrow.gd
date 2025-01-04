extends Area2D

@export var speed = 750

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_body_entered(_body):
	queue_free()
