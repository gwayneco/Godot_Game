extends PathFollow2D

var speed = 0.1
var BossEnteredFlas = 0
var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	progress_ratio = 0.5
	GlobalVar.StartPosInScreen = $StartPosInScreen.position
	print($StartPosInScreen.position)
	#print(GlobalVar.StartPosInScreen)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(position.x)
	if (BossEnteredFlas):
		progress_ratio += delta * speed * direction
		if (progress_ratio == 1 or progress_ratio == 0):
			direction *= -1

func _on_dog_boss_1_boss_entered():
	BossEnteredFlas = 1
	print("emit")
