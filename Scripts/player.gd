extends Area2D

signal hit
signal bonus_pick_up
signal dog_damage
signal coin_up

var speed = 400
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
	velocity.x = Input.get_axis("ui_left", "ui_right")
	velocity.y = Input.get_axis("ui_up", "ui_down")

	if velocity.length() > 0:
		velocity = velocity.normalized()

	position += velocity * delta  * speed
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
	elif body.is_in_group("coin"):
		body.queue_free()
		emit_signal("coin_up")
