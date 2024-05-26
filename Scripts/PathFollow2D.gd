extends PathFollow2D

var speed = 100
var BossEnteredFlas = 1
var direction = 1
var rng = RandomNumberGenerator.new()
# Флаг для того, чтобы запускалась анимация смерти только один раз
var BossDieFlag = 1
export var FireBallScene: PackedScene
#var speed = 5

func _ready():
	unit_offset = 0.5
	#$DogBoss1.position.x = 768

func _process(delta):
	if (BossDieFlag):
		_boss_movement()
	if (GlobalVar.BossLifes == 0 and BossDieFlag):
#		emit_signal("boss_died")
		_boss_died()

func _boss_movement():
	#Передвижение босса в сцену, пока он не достигнет середины экрана
	if ($DogBoss1.is_inside_tree()):
		if ($DogBoss1.position.y < $Marker2D.position.y and BossEnteredFlas):
			$DogBoss1.velocity = $DogBoss1.position.direction_to($Marker2D.position) * speed
		
		elif (BossEnteredFlas):
			$FireTimer.start()
			$DogBoss1.velocity = Vector2.ZERO
			$DirectionChangeTimer.start()
			BossEnteredFlas = 0
		if (!BossEnteredFlas):
			direction = _Path2dFollowBoss(direction)

# ФУнкция для перемещения босса по пути
func _Path2dFollowBoss(direction):
	if (direction == 1):
		unit_offset += 0.0020
		if (unit_offset >= 0.993):
			direction *= -1
	else:
		unit_offset -= 0.0020
		if (unit_offset <= 0.01):
			direction *= -1
	return direction

func _on_dog_boss_1_boss_entered():
	BossEnteredFlas = 1


func _on_DirectionChangeTimer_timeout():
	if (rng.randi_range(0,1)):
		direction *= -1
	else:
		pass

func _on_FireTimer_timeout():
	var FireBall = FireBallScene.instance()
	get_tree().root.add_child(FireBall)
	FireBall.start(global_position - Vector2(0,-150))
	FireBall.velocity = position.direction_to(GlobalVar.PlayerPosition) * 500
	FireBall.rotation = get_angle_to(GlobalVar.PlayerPosition)
	if ($FireTimer.wait_time > 0.5):
		$FireTimer.wait_time -= 0.01
	
#Функция при смерти босса, вызывается при достижении его жизней = 0
func _boss_died():
	BossDieFlag = 0
	$FireTimer.stop()
	if ($DogBoss1.position.y > $OutScreenDied.position.y):
		$DogBoss1.velocity = $DogBoss1.position.direction_to($OutScreenDied.position) * speed
	$BossDieSound.play()


func _on_VisibilityNotifier2D_screen_exited():
	if (BossDieFlag == 0):
		Signals.emit_signal("boss1_died")
		$DogBoss1.queue_free()
