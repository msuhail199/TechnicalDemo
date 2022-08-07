extends AnimatedSprite

onready var Player = get_owner()
onready var Muzzle = $Muzzle


func flip_gun():
	if Input.is_action_pressed("right"):
		#Muzzle.position.y = max(Muzzle.position.y, -Muzzle.position.y)
		#look_at(Vector2(Player.position.x + 100, Player.position.y + 36))
		position = Vector2(46,36)
		Muzzle.position = Vector2(558, -210)
		animation = "Right"
	elif Input.is_action_pressed("left") :
		#Muzzle.position.y = max(Muzzle.position.y, -Muzzle.position.y)
		animation = "Left"
		position = Vector2(0, 36)
		Muzzle.position = Vector2(-558,-210)
		#look_at(Vector2(Player.position.x - 100, Player.position.y +36))		


func _process(delta):
# 	#flip according to direction
	flip_gun()

func _ready():
	visible = false
	set_process(true)
