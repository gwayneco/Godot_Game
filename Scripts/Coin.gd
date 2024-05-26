extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite.rotation += 0.01
	$CollisionShape2D.rotation += 0.01

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
