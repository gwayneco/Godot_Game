extends Node

export var FireBallScene: PackedScene

var width_screen = ProjectSettings.get_setting("display/window/size/width")
var height_screen = ProjectSettings.get_setting("display/window/size/height")

var Vectors_array = [Vector2(1,0),Vector2(1,1) , Vector2(0,1),Vector2(-1,1),Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1),Vector2(1,-1)]

var speed = 350
var moving_in_scene_flag = 1
var BossDieFlag = 1

func _ready():
	$Char_DogBoss2.position.x = 960
	$Char_DogBoss2.position.y = -260

func _boss_movement():
	#Передвижение босса в сцену, пока он не достигнет середины экрана
	if (is_inside_tree()):
		if ($Char_DogBoss2.position.y < $Marker2D.position.y and moving_in_scene_flag):
			$Char_DogBoss2.velocity = $Char_DogBoss2.position.direction_to($Marker2D.position) * speed
		else:
#			Включаем таймер, чтобы после входа в сцену босс начал двигаться в рандомные направления
			moving_in_scene_flag = 0
			$Char_DogBoss2.velocity = Vector2.ZERO
			$Marker2D.position = Vector2(rand_range(150,width_screen - 150), rand_range(150, height_screen - 150))


func _process(delta):
	if (GlobalVar.BossLifes2 == 0 and BossDieFlag):
#		emit_signal("boss_died")
		_boss_died()
	if (moving_in_scene_flag and BossDieFlag):
		_boss_movement()
		$FireTimer.start()
	elif (BossDieFlag):
		_Change_Directory_Boss()
		$Char_DogBoss2.velocity = $Char_DogBoss2.position.direction_to($Marker2D.position) * speed

func _Change_Directory_Boss():
	if ((($Char_DogBoss2.position.x - $Marker2D.position.x) < 20 and ($Char_DogBoss2.position.y - $Marker2D.position.y) < 20) or  (($Char_DogBoss2.position.x + $Marker2D.position.x) < 20 and ($Char_DogBoss2.position.y + $Marker2D.position.y) < 20)):
		$Marker2D.position = Vector2(rand_range(150,width_screen - 150), rand_range(150, height_screen - 150))
	pass

func _on_FireTimer_timeout():
	_fire_spawner()


func _fire_spawner():
	var rotation_scaler = 0
	for i in Vectors_array:
		var FireBall = FireBallScene.instance()
		FireBall.rotation_degrees = rotation_scaler
		get_tree().root.add_child(FireBall)
		FireBall.start($Char_DogBoss2.global_position + $Char_DogBoss2.velocity / speed * 30 + Vector2(0,-80))
		rotation_scaler += 45 
		FireBall.velocity = i * 400

#Босс убит персонажем
func _boss_died():
	BossDieFlag = 0
	$FireTimer.stop()
	if ($Char_DogBoss2.position.y > $OutScreenDied.position.y):
		$Char_DogBoss2.velocity = $Char_DogBoss2.position.direction_to($OutScreenDied.position) * speed
	$Char_DogBoss2._boss_died()
	

func _on_VisibilityNotifier2D_screen_exited():
	if (BossDieFlag == 0):
		Signals.emit_signal("boss1_died")
		$Char_DogBoss2.queue_free()
