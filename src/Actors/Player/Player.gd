extends KinematicBody2D


# Const Values
const speed = 800
const jumpSpeed = 600
const slowdown = 30
const GRAVITY = 30
const airboost = -10

# Start pos
onready var startpos = position
onready var inc = 0.1

var velocity = Vector2()
onready var Bullet = load("res://src/Actors/Objects/Projectiles/Bullet.tscn")
onready var raycastleft =  get_node("RayCastLeft")
onready var raycastright = get_node ("RayCastRight")
onready var gun = get_node("Gun")

enum DIRECTION {
	LEFT = -1
	NONE = 0
	RIGHT = 1
}

var initial = DIRECTION.NONE

func grad_increase():
	if Input.is_action_pressed("right"):
		return (velocity.x + speed*0.1) if (velocity.x < speed) else velocity.x
	elif Input.is_action_pressed("left"):
		return (velocity.x + -speed*0.1) if (velocity.x > -speed) else velocity.x
	else:
		return velocity.x

# in air function
func in_air():
	# Apply Gravity in the air.
	velocity.y += GRAVITY
	
	if Input.is_action_pressed("up") && velocity.y < 0:
		velocity.y += airboost

	# Apply horizontal movement in air (Gradually)
	if Input.is_action_pressed("right"):
		velocity.x = grad_increase()
	elif Input.is_action_pressed("left"):
		velocity.x = grad_increase()
	else : # No button press
		if velocity.x != 0 : # Currently moving, slowdown
			velocity.x += slowdown if (velocity.x < 0) else -slowdown

func on_ground():
	# Set Initial Direction.
	initial = DIRECTION.NONE
	# Sideways input and on ground
	if Input.is_action_pressed("right"):
		velocity.x = grad_increase()
	elif Input.is_action_pressed("left"):
		velocity.x = grad_increase()
	else:
		velocity.x = 0
	
	# Jump Input
	if Input.is_action_just_pressed("up"):
		velocity.y = -jumpSpeed
		if velocity.x > 0 :
			initial = DIRECTION.RIGHT
		elif velocity.x < 0 :
			initial = DIRECTION.LEFT

# Effectively the main function
func get_input():
	# show or hide gun
	if Input.is_action_just_pressed("gun"):
		gun.visible = !gun.visible
	
	if Input.is_action_just_pressed("Restart"): # Restart game
		position = startpos
	
	# do is _on_floor and then call in_air or on_ground#
	if raycastleft.is_colliding() or raycastright.is_colliding():
		#print("FLOOR!")
		if gun.visible && Input.is_action_just_pressed("Shoot"):
			on_shoot()
		on_ground()
	else:
		#print("AIR!")
		if gun.visible && Input.is_action_just_pressed("Shoot"):
			on_shoot(true)
		in_air()

# Called each frame
func _physics_process(delta):
	get_input()
	velocity = move_and_slide_with_snap(velocity, Vector2.UP)


func on_shoot(var air = false):
	# 1 for right -1 for left
	var facing = -1 if (gun.animation == "Left") else 1
	var b = Bullet.instance()
	b.init(facing)
	owner.add_child(b)
	b.transform = get_node("Gun/Muzzle").global_transform
	velocity.x -= facing*speed*2
