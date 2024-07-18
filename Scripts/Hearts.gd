extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.visible = false
	$AnimatedSprite.modulate.a8 = 90
	$AnimatedSprite.frame = 0
	Signals.connect("from_hud_gameover", self, "hide_hearts")

func _on_Player_dog_damage():
	if (GlobalVar.Number_of_Boss_flag == 1):
		$AnimatedSprite.frame += 1
		if (GlobalVar.BossLifes == 0):
			$AnimatedSprite.visible = false
	elif (GlobalVar.Number_of_Boss_flag == 2):
		$AnimatedSprite.frame += 1
		if (GlobalVar.BossLifes2 == 0):
			$AnimatedSprite.visible = false


func _on_BossTimer1_timeout():
	$AnimatedSprite.visible = true
	$AnimatedSprite.frame = 0


func _on_BossTimer2_timeout():
	$AnimatedSprite.visible = true
	$AnimatedSprite.frame = 0


func _on_HUD_start_game():
	$AnimatedSprite.visible = false
	$AnimatedSprite.modulate.a8 = 90
	$AnimatedSprite.frame = 0

func hide_hearts():
	$AnimatedSprite.visible = false
