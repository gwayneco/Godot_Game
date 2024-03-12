extends Area2D
signal hit
signal bonus_pick_up
signal dog_damage

var speed = 600
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

func start(pos):
	$AnimatedSprite.play()
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		#$AnimatedSprite2D.play()
	#else:
		#$AnimatedSprite2D.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	look_at(global_position + velocity)



func _on_body_entered(body):
	if body.is_in_group("mobs"):
		hide()
		emit_signal("hit")
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite.stop()
	elif body.is_in_group("bonus"):
		emit_signal("bonus_pick_up")
	elif body.is_in_group("dog_damage"):
		emit_signal("dog_damage")
