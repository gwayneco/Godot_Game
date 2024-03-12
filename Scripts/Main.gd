extends Node

export var mob_scene: PackedScene
export var bonus_scene: PackedScene
export var Boss_scene: PackedScene
export var lapka_scene: PackedScene

var Boss
var score
var flag = 1

func _ready():
	$Player.hide()

func _process(delta):
	GlobalVar.PlayerPosition = $Player.position

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
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.unit_offset = randf()
	#print(mob_spawn_location.global_position)
	var direction = mob_spawn_location.rotation + PI / 2

	direction += rand_range(-PI / 4, PI / 4)
	GlobalVar.mob_spawn_location_position = mob_spawn_location.global_position
	GlobalVar.mob_direction = direction
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_bonus_spawn_timer_timeout():
	var bonus = bonus_scene.instance()
	var bonus_spawn_location = get_node("MobPath/MobSpawnLocation")
	bonus_spawn_location.unit_offset = randf()
	var direction = bonus_spawn_location.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	bonus.position = bonus_spawn_location.global_position
	bonus.rotation = direction
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	bonus.linear_velocity = velocity.rotated(direction)
	add_child(bonus)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
	
	# Ускорение появления врагов
	if (score != 0.05 and score % 2 == 0):
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
	var position_bonux_x = rand_range(0 + indent_x,size_x - indent_x)
	var position_bonux_y = rand_range(0 + indent_y,size_y - indent_y)
	
	return [position_bonux_x,position_bonux_y]
	
func _on_boss_timer_1_timeout():
	_boss1_entired()
	$BossTimer1.stop()

func _boss1_entired():
	Boss = Boss_scene.instance()
	$Music.stop()
	$BonusPickMusic.stop()
	$BossMusic1.play()
	$MobTimer.stop()
	$SpawnBonusTimer.stop()
	add_child(Boss)
	$LapkaDamageBossTimer.start()
	
	
func _on_player_dog_damage():
	get_tree().call_group("dog_damage", "queue_free")
	GlobalVar.BossLifes -= 1
	Boss.get_node("BossPath").get_node("DogBoss1")._damage()
	$CatDoDamage.play()
	if (GlobalVar.BossLifes == 0):
		$BossMusic1.stop()
		$LapkaDamageBossTimer.stop()

func _on_lapka_damage_boss_timer_timeout():
	var lapka = lapka_scene.instance()
	var lapka_spawn_location = get_node("MobPath/MobSpawnLocation")
	lapka_spawn_location.unit_offset = randf()
	var direction = lapka_spawn_location.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	lapka.position = lapka_spawn_location.global_position
	lapka.rotation = direction
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	lapka.linear_velocity = velocity.rotated(direction)
	add_child(lapka)

func _observer():
	pass
