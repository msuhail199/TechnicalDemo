extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const speed = 500
const jumpSpeed = 700
var velocity = Vector2()
onready var raycastleft =  get_node("RayCastLeft")
onready var raycastright = get_node ("RayCastRight")

enum DIRECTION {
	LEFT = -1
	NONE = 0
	RIGHT = 1
}

var initial = DIRECTION.NONE

# Const values 
const GRAVITY = 30

func is_on_floor_custom():
	if raycastleft.is_colliding() or raycastright.is_colliding():
		return true
	else:
		return false


# in air function
func in_air():
	# Apply Gravity in the air.
	velocity.y += GRAVITY
	
	# Apply horizontal movement in air
	if Input.is_action_pressed("right"):
		velocity.x = speed if initial == DIRECTION.RIGHT else speed * 0.4
	elif Input.is_action_pressed("left"):
		velocity.x = -speed if initial == DIRECTION.LEFT else -speed * 0.4
	else:
		velocity.x += 10 if (velocity.x < 0) else -10

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
	# do is _on_floor and then call in_air or on_ground
	print("Travelling in Direction : " + str(initial))
	if is_on_floor_custom(): 
		print("FLOOR!")
		on_ground()
	else:
		print("AIR!")
		in_air()

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity, Vector2.UP)
