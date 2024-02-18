extends Node

@export var mob_scene: PackedScene
@export var bonus_scene: PackedScene
@export var Boss_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$SpawnBonusTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$BossTimer1.start()
	$HUD.update_score(score)
	$Music.play()
	$MobTimer.start()
	$ScoreTimer.start()
	$SpawnBonusTimer.start()
	$MobTimer.wait_time = 2
	

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	var direction = mob_spawn_location.rotation + PI / 2

	direction += randf_range(-PI / 4, PI / 4)
	GlobalVar.mob_spawn_location_position = mob_spawn_location.position
	GlobalVar.mob_direction = direction
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_bonus_spawn_timer_timeout():
	var bonus = bonus_scene.instantiate()
	var bonus_spawn_location = get_node("MobPath/MobSpawnLocation")
	bonus_spawn_location.progress_ratio = randf()
	var direction = bonus_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	bonus.position = bonus_spawn_location.position
	bonus.rotation = direction
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	bonus.linear_velocity = velocity.rotated(direction)
	
	#get_tree().call_group("bonus", "queue_free")
	
	#var position_bonus = _bonus_spawn_location(get_tree().root.size.x, get_tree().root.size.y)
	#bonus.position.x = position_bonus[0]
	#bonus.position.y = position_bonus[1]
	add_child(bonus)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
	
	# Ускорение появления врагов
	if (score != 0.5 and score % 3 == 0):
		$MobTimer.wait_time -= 0.05

func _on_player_bonus_pick_up():
	get_tree().call_group("bonus", "queue_free")
	GlobalVar.mob_speed_var = GlobalVar.mob_speed_var - GlobalVar.mob_speed_var * 0.5
	$Music.stream_paused = true
	$BonusPickMusic.play()
	$DurationBonusTimer.start()
	get_tree().call_group("mobs", "_bonus_activate")

func _on_duration_bonus_timer_timeout():
	GlobalVar.mob_speed_var = GlobalVar.mob_speed_constant
	$BonusPickMusic.stop()
	$Music.stream_paused = false
	
func _bonus_spawn_location(size_x, size_y):
	var indent_x = size_x * 0.1
	var indent_y = size_y * 0.1
	var position_bonux_x = randf_range(0 + indent_x,size_x - indent_x)
	var position_bonux_y = randf_range(0 + indent_y,size_y - indent_y)
	
	return [position_bonux_x,position_bonux_y]
	
func _on_boss_timer_1_timeout():
	print("BOSS")
	_boss1_entired()
	$BossTimer1.stop()

func _boss1_entired():
	print("12")
	var Boss = Boss_scene.instantiate()
	$Music.stop()
	$BonusPickMusic.stop()
	$BossMusic1.play()
	$MobTimer.stop()
	$SpawnBonusTimer.stop()
	add_child(Boss)

