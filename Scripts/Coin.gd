extends KinematicBody2D
signal coin_magnit()
var velocity = Vector2.ZERO
var flag_coin_magnited = 0

func _ready():
	$AnimatedSprite.play("default")
#	Signals.connect("coin_magnit", self, "_coin_magnited")

func _physics_process(delta):
	move_and_slide(velocity)
	$AnimatedSprite.rotation += 0.01
	$CollisionShape2D.rotation += 0.01
	if (get_slide_count() != 0):
		print(get_slide_count())
	if (flag_coin_magnited):
		velocity = position.direction_to(GlobalVar.PlayerPosition) * 500
#	for i in get_slide_count():
#		print(str(get_slide_collision(i).collider.name))
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Coin_coin_magnit():
	velocity = position.direction_to(GlobalVar.PlayerPosition) * 500
	flag_coin_magnited = 1
