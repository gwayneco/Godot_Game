extends KinematicBody2D

var velocity = Vector2.ZERO
signal BossEntered
var FlagBossIsOn = 1

var t = 0.0
var x = 0
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("attack")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	move_and_slide(velocity)
	

func _damage():
	$AnimatedSprite.stop()
	$AnimatedSprite.play("damage") 

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite.play("attack")


func _on_BossPath_boss_died():
	$AnimatedSprite.stop()
	$AnimatedSprite.play("die")
