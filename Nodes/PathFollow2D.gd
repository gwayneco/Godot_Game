extends PathFollow2D

var speed = 1
var BossEnteredFlas = 1
var direction = 1
var StartPosInScreen
#var speed = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	progress_ratio = 0.5
	StartPosInScreen = $StartPosInScreen.position
	#$DogBoss1.position.x = 768
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Передвижение босса в сцену, пока он не достигнет середины экрана
	if ($DogBoss1.position != StartPosInScreen and BossEnteredFlas):
		$DogBoss1.velocity = $DogBoss1.position.direction_to(StartPosInScreen) * speed
		$DogBoss1.position += $DogBoss1.velocity
	elif (BossEnteredFlas):
		BossEnteredFlas = 0
	if (!BossEnteredFlas):
		direction = Path2dFollowBoss(direction)
		
		
# ФУнкция для перемещения босса по пути
func Path2dFollowBoss(direction):
	if (direction == 1):
		progress_ratio += 0.0005
		if (progress_ratio == 1):
			direction *= -1
	else:
		progress_ratio -= 0.0005
		if (progress_ratio == 0):
			direction *= -1
	return direction

func _on_dog_boss_1_boss_entered():
	BossEnteredFlas = 1
	print("emit")
