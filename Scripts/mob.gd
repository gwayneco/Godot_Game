extends RigidBody2D

signal bonus_activate

var velocity = Vector2(0.0, 0.0)
var direction

func _ready():
	direction = GlobalVar.mob_direction
	#rotation = direction
	position = GlobalVar.mob_spawn_location_position
	velocity = Vector2(200, 0.0) * GlobalVar.mob_speed_var

func _process(delta):
	velocity = Vector2(200, 0.0) * GlobalVar.mob_speed_var
	linear_velocity = velocity.rotated(direction)
	$Sprite.rotation += 0.01
	$CollisionShape2D.rotation += 0.01

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _bonus_activate():
	pass
