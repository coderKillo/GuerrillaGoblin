class_name Arrow
extends Area2D

@export var speed = 1000


func _ready():
	body_entered.connect(_on_Bullet_body_entered)


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_Bullet_body_entered(body):
	if body.has_method("hit"):
		body.hit()
	queue_free()
