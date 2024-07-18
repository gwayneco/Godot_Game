extends KinematicBody2D

var velocity = Vector2.ZERO
var BossDieFlagInside = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("Stay") 
	pass # Replace with function body.

func _physics_process(delta):
	move_and_slide(velocity)
	
func _damage():
	$AnimatedSprite.stop()
	$AnimatedSprite.play("Damage")

func _boss_died():
	BossDieFlagInside = 0
	$AnimatedSprite.play("Die")


func _on_AnimatedSprite_animation_finished():
	if (BossDieFlagInside):
		$AnimatedSprite.play("Stay")
