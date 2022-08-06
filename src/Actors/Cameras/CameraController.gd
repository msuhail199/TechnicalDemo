extends Camera2D


onready var player = get_node("/root/Node/Player")

func _physics_process(delta):
	position.x = player.position.x
