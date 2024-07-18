extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite.rotation += 0.01
	$CollisionShape2D.rotation += 0.01


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
