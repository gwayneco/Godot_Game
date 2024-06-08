extends RigidBody2D

var velocity = Vector2(0.0, 0.0)
var direction
var speed_multiplier = 1

func _ready():
	if (GlobalVar.Sprite_name == "Asteroid"):
		$Sprite.play("Asteroid")
	elif (GlobalVar.Sprite_name == "Cow"):
		$Sprite.play("Cow")
	
	direction = GlobalVar.mob_direction
	#rotation = direction
	position = GlobalVar.mob_spawn_location_position
	velocity = Vector2(200, 0.0) * GlobalVar.mob_speed_var
	Signals.connect("polish_cow", self, "_polish_cow_dance")
	Signals.connect("asteroid_sprite", self, "_asteroid_sprite")
	Signals.connect("boss_entered_leave_mobs",self,"_boss_enter_in_game")
	Signals.connect("boss_killed_return_mobs",self,"_boss_killed")

func _process(delta):
	velocity = Vector2(10090, 0.0) * GlobalVar.mob_speed_var * speed_multiplier
	linear_velocity = velocity.rotated(direction) * delta
	$Sprite.rotation += 0.01
	$CollisionShape2D.rotation += 0.01

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _polish_cow_dance():
	GlobalVar.Sprite_name = "Cow"
	$Sprite.play("Cow")

func _asteroid_sprite():
	GlobalVar.Sprite_name = "Asteroid"
	$Sprite.play("Asteroid")

func _boss_enter_in_game():
	$CollisionShape2D.disabled = true
	speed_multiplier = 5

func _boss_killed():
	$CollisionShape2D.disabled = false
	speed_multiplier = 1
