class_name Player
extends Actor



# Const Values
const speed = 600
const jumpSpeed = 600
const slowdown = 30
const airboost = -10

# Start pos
onready var startpos = position
onready var inc = 0.1

export var maxhealth = 100

onready var raycastleft =  get_node("RayCastLeft")
onready var raycastright = get_node ("RayCastRight")
onready var gun = get_node("Gun")
onready var health:int = maxhealth


# Gradually increase speed until max velocity.
func grad_increase():
	if Input.is_action_pressed("right"):
		return (velocity.x + speed*0.1) if (velocity.x < speed) else velocity.x
	elif Input.is_action_pressed("left"):
		return (velocity.x + -speed*0.1) if (velocity.x > -speed) else velocity.x
	else:
		return velocity.x
	

# Effectively the main function
func get_input():
	# show or hide gun
	if Input.is_action_just_pressed("gun"):
		gun.visible = !gun.visible
	
	if gun.visible && Input.is_action_just_pressed("Shoot"): # Call item action function
		gun.on_shoot()
	
	if Input.is_action_just_pressed("Restart"): # Restart Test
		position = startpos
	
	if Input.is_action_pressed("jump"):
		if check_for_ground():
				jump()
		else:
			if velocity.y < 0:
				velocity.y += airboost
	
	# Sideways input/slowdown if no imput
	if Input.is_action_pressed("right"):
		velocity.x = grad_increase()
	elif Input.is_action_pressed("left"):
		velocity.x = grad_increase()
	else:
		if check_for_ground() : 
			# Decrease or stop movement
			if fposmod(velocity.x, 1.0) < 1:
				velocity.x = 0;
			else:
				velocity.x += -velocity.x * 0.2
		else:
			if velocity.x != 0 : # Currently moving, slowdown
				velocity.x += slowdown if (velocity.x < 0) else -slowdown


func check_for_ground():
	# return true if on ground else false
	if raycastleft.is_colliding() or raycastright.is_colliding():
		#print("FLOOR!")
		return true
	else:
		#print("AIR!")
		return false

func apply_knockback(var facing:int = 0, var height:int = 0):
	# Push the player back after they fire.
	var pushback = facing * speed * 2
	velocity.x -= pushback/2 if check_for_ground() else pushback
	velocity.y += height * (jumpSpeed/2)

func take_damage(var damage:float):
	health -= damage

func jump():
	velocity.y = -jumpSpeed

# Called each frame
func _physics_process(delta):
	# Apply Gravity in the air.
	velocity.y += GRAVITY
	get_input()
	velocity = move_and_slide(velocity, Vector2.UP)
