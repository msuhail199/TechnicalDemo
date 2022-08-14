class_name Actor
extends KinematicBody2D


var velocity = Vector2()
onready var GRAVITY = 30


func _physics_process(delta):
	#velocity.y += GRAVITY
	var x = 1
