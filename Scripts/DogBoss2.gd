extends Node

export var FireBallScene: PackedScene

var width_screen = ProjectSettings.get_setting("display/window/size/width")
var height_screen = ProjectSettings.get_setting("display/window/size/height")

var speed = 500
var moving_in_scene_flag = 1

func _ready():
	$Char_DogBoss2.position.x = 960
	$Char_DogBoss2.position.y = -260
	print(is_inside_tree())

func _boss_movement():
	#Передвижение босса в сцену, пока он не достигнет середины экрана
	if (is_inside_tree()):
		if ($Char_DogBoss2.position.y < $Marker2D.position.y and moving_in_scene_flag):
			$Char_DogBoss2.velocity = $Char_DogBoss2.position.direction_to($Marker2D.position) * speed
			print ($Char_DogBoss2.global_position)
		else:
#			Включаем таймер, чтобы после входа в сцену босс начал двигаться в рандомные направления
			moving_in_scene_flag = 0
			$Char_DogBoss2.velocity = Vector2.ZERO
			$Marker2D.position = Vector2(rand_range(150,width_screen - 150), rand_range(150, height_screen - 150))


func _process(delta):
	if (moving_in_scene_flag):
		_boss_movement()
	else:
		_Change_Directory_Boss()
		$Char_DogBoss2.velocity = $Char_DogBoss2.position.direction_to($Marker2D.position) * speed

#func _physics_process(delta): 
#	print($Marker2D.global_position)
#	_boss_movement()
#	#print(velocity)
#	move_and_slide(velocity)


func _Change_Directory_Boss():
	if ((($Char_DogBoss2.position.x - $Marker2D.position.x) < 20 and ($Char_DogBoss2.position.y - $Marker2D.position.y) < 20) or  (($Char_DogBoss2.position.x + $Marker2D.position.x) < 20 and ($Char_DogBoss2.position.y + $Marker2D.position.y) < 20)):
		$Marker2D.position = Vector2(rand_range(150,width_screen - 150), rand_range(150, height_screen - 150))
		print($Marker2D.position)


#func _on_FireTimer_timeout():
#	var FireBall = FireBallScene.instance()
#	get_tree().root.add_child(FireBall)
#	get_tree().root.add_child(FireBall)
#	get_tree().root.add_child(FireBall)
#	get_tree().root.add_child(FireBall)-
#	FireBall.start($Char_DogBoss2.global_position - Vector2(0,-150))
#	FireBall.velocity = $Char_DogBoss2.position.direction_to(GlobalVar.PlayerPosition) * 500
#	FireBall.rotation = $Char_DogBoss2.get_angle_to(GlobalVar.PlayerPosition)
#	if ($FireTimer.wait_time > 0.5):
#		$FireTimer.wait_time -= 0.01
