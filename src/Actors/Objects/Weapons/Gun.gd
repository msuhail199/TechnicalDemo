extends AnimatedSprite

class_name ShotGun

onready var Player = get_owner()
onready var Bullet = load("res://src/Actors/Objects/Projectiles/Bullet.tscn")
onready var Muzzle = $Muzzle

onready var downpos = Vector2(23, 36)
onready var leftpos = Vector2(0,36)
onready var rightpos = Vector2(46,36)

onready var muzzleleft = Vector2(558,-210)
onready var muzzleright = Vector2(-558,-210)
onready var muzzledown = Vector2(0, 900)

var allowshoot:bool = true
onready var time_between_shots:float = 0.5


func flip_gun():
	if Input.is_action_pressed("right"):
		position = rightpos
		Muzzle.position = muzzleleft
		animation = "Right"
	elif Input.is_action_pressed("left") :
		animation = "Left"
		position = leftpos
		Muzzle.position = muzzleright
	if Input.is_action_pressed("down") :
		animation = "Down"
		position = downpos
		Muzzle.position = muzzledown
		

func on_shoot(var _air:bool = false):
	# Declare Bullet, add to muzzle position
	if !allowshoot:
		return
	
	allowshoot = false
	var direction = Vector2()
	if animation == "Down":
		direction.y = 1
		Player.apply_knockback(0, -1)
	elif animation == "Left":
		direction.x = -1
		Player.apply_knockback(-1)
	elif animation == "Right":
		Player.apply_knockback(1)
		direction.x = 1
	
	# Create and configure bullet.
	var b = Bullet.instance()
	b.init(direction)
	print(direction)
	b.set_as_toplevel(true)
	add_child(b)
	b.transform = Muzzle.global_transform
	yield(get_tree().create_timer(time_between_shots), "timeout")
	allowshoot = true
	
func _process(_delta):
# 	#flip according to direction
	flip_gun()

func _ready():
	visible = false
	animation = "Right"
	set_process(true)
