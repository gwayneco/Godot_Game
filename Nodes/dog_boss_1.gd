extends RigidBody2D

var t = 0.0
var x = 0
var velocity = Vector2(0.0, 0.0)
var target = $StartPosInScreen.position
var speed = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	position = $StartPosOutScreen.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	# look_at(target)
	if position.distance_to(target) > 10:
