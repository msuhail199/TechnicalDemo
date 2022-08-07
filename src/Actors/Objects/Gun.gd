extends Sprite

onready var Player = get_owner()


func flip_gun():
	if Input.is_action_pressed("right"):
		look_at(Vector2(Player.position.x + 100, Player.position.y + 36))
		set_flip_v(false)
		position = Vector2(46,36)
	elif Input.is_action_pressed("left") :
		position = Vector2(0, 36)
		look_at(Vector2(Player.position.x - 100, Player.position.y +36))
		set_flip_v(true)


func _process(delta):
	#flip according to direction
	flip_gun()
	
	#var mpos = get_global_mouse_position()
	#if mpos.x < Player.position.x : 
	#	print("Neg")
	#	set_flip_v(true)
	#else :
	#	print("pos")
	#	set_flip_v(false)
	#look_at(mpos)
	#print(mpos)

func _ready():
	visible = false
	set_process(true)
