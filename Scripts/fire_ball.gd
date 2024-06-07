extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 500
var StartFlag = 10
var test = Vector2.ZERO
var direction
# Called when the node enters the scene tree for the first time.
func start(pos):
	$AnimatedSprite.play("Fly")
	#direction += randf_range(-PI / 4, PI / 4)
	position = pos
#	velocity = position.direction_to(GlobalVar.PlayerPosition) * speed
#	rotation = get_angle_to(GlobalVar.PlayerPosition)


func _physics_process(delta):
	move_and_slide(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
