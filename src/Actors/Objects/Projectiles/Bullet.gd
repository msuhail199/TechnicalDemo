extends Area2D

var speed = 400
var dir = 1


func _physics_process(delta):
	position += transform.x * speed * dir
	
func init(var direction):
	dir = direction
	

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
