extends Node2D


class_name Bullet

var speed = 25
var dir = Vector2(0,0)

func init(direction:Vector2):
	dir = direction
	

func _physics_process(delta):
	position.x += dir.x * speed
	position.y += dir.y * speed

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
	

