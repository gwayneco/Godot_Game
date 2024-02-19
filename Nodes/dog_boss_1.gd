extends RigidBody2D

@export var FireBallScene: PackedScene
signal BossEntered
var FlagBossIsOn = 1

var t = 0.0
var x = 0
var velocity = Vector2(0.0, 0.0)
var target
var speed = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	#print("Global: ", GlobalVar.StartPosInScreen[0])
	#print(position.y)
	#
	#if position.y <= (GlobalVar.StartPosInScreen[0] - 10) and FlagBossIsOn:
		#velocity = position.direction_to(GlobalVar.StartPosInScreen) * speed
		#FlagBossIsOn = 0
		#BossEntered.emit()
	#else:
		#velocity = Vector2.ZERO
	pass


func _on_fire_timer_timeout():
	#print("Fire")
	#var FireBall = FireBallScene.instantiate()
	#print(GlobalVar.AttackMarkerPosition)
	#FireBall.position.x = GlobalVar.AttackMarkerPosition
	#FireBall.position.y = 256
	#owner.add_child(FireBall)
	pass
