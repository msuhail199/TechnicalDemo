extends KinematicBody2D


# Const Values
const speed = 400
const jumpSpeed = 600
const slowdown = 30
const GRAVITY = 30
const airboost = -10

# Start pos
onready var startpos = position

var velocity = Vector2()
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
		return (velocity.x + speed*0.05) if (velocity.x < speed) else velocity.x
	elif Input.is_action_pressed("left"):
		return (velocity.x + -speed*0.05) if (velocity.x > -speed) else velocity.x
	else:
		return velocity.x

# in air function
func in_air():
	# Apply Gravity in the air.
	velocity.y += GRAVITY
	
	if Input.is_action_pressed("up") && velocity.y < -10:
		velocity.y += airboost

	# Apply horizontal movement in air (Gradually)
	if Input.is_action_pressed("right"):
		velocity.x = speed if initial == DIRECTION.RIGHT else grad_increase()
	elif Input.is_action_pressed("left"):
		velocity.x = -speed if initial == DIRECTION.LEFT else grad_increase()
	else : # No button press
		if velocity.x != 0 : # Currently moving, slowdown
			velocity.x += slowdown if (velocity.x < 0) else -slowdown

func on_ground():
	# Set Initial Direction.
	initial = DIRECTION.NONE
	
	# Sideways input and on ground
	if Input.is_action_pressed("right"):
		velocity.x = speed
	elif Input.is_action_pressed("left"):
		velocity.x = -speed
	else:
		velocity.x = 0
	
	# Jump Input
	if Input.is_action_just_pressed("up"):
		velocity.y = -jumpSpeed
		if velocity.x > 0 :
			initial = DIRECTION.RIGHT
		elif velocity.x < 0 :
			initial = DIRECTION.LEFT
	
func get_input():
	# show or hide gun
	if Input.is_action_just_pressed("gun"):
		gun.visible = !gun.visible
	
	if Input.is_action_just_pressed("Restart"): # Restart game
		position = startpos
	
	# do is _on_floor and then call in_air or on_ground#
	if raycastleft.is_colliding() or raycastright.is_colliding():
		print("FLOOR!")
		on_ground()
	else:
		print("AIR!")
		in_air()

func _physics_process(delta):
	get_input()
	velocity = move_and_slide_with_snap(velocity, Vector2.UP)
