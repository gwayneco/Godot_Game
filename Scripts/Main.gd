extends Node

export var mob_scene: PackedScene
export var bonus_scene: PackedScene
export var Boss_scene1: PackedScene
export var Boss_scene2: PackedScene
export var lapka_scene: PackedScene
export var coin_scene: PackedScene
var toggleMusicCallback = JavaScript.create_callback(self,"toggleMusic") # Ставит игру на паузу при сворачивании браузера и окна браузера

var Boss
var score_local
var flag = 1


func _ready():
	$Player.hide()
	JavaScript.get_interface('window').addEventListener('visibilitychange',toggleMusicCallback)
	Signals.connect("boss1_died", self, "_resume_game_after_boss")
	Signals.connect("from_hud_gameover", self, "game_over")
	$MainMenuMusic.play()
	randomize()

func toggleMusic(event): # Ставит игру на паузу при сворачивании браузера и окна браузера
	var visibility = JavaScript.get_interface('document').visibilityState
	if visibility=='hidden':
		get_tree().paused=true
	elif visibility=='visible':
		get_tree().paused=false

func game_over():
	get_tree().call_group("service", "queue_free")
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("coin", "queue_free")
	get_tree().call_group("bonus", "queue_free")
	$SpeedSpawnMobsTimer.stop()
	$MobTimer.stop()
	$MobTimer.stop()
	$SpawnBonusTimer.stop()
	$Music.stop()
#	$DeathSound.play() Перенесено в hud.last_chance()
	$BossMusic1.stop()
	$LapkaDamageBossTimer.stop()
	$BossTimer1.stop()
	$BossTimer2.stop()
	$AfterBossCoinStorm.stop()
	$CoinTimer.stop()
	$DurationBonusTimer.stop()
	$MainMenuMusic.play()
	$Hearts.hide()
	$BonusPickMusic.stop()
#	if Bridge.platform.id == "yandex":


func _on_HUD_set_score_to_leaderboard():
	var get_score_options = Bridge.GetScoreYandexOptions.new("CatsLeaderboard2")
	Bridge.leaderboard.get_score(get_score_options, funcref(self, "_on_get_score_completed"))

func _on_set_score_completed(success):
	pass


func _on_get_score_completed(success, score):
	if (score < score_local):
		var set_score_options = Bridge.SetScoreYandexOptions.new(score_local, "CatsLeaderboard2")
		Bridge.leaderboard.set_score(set_score_options, funcref(self, "_on_set_score_completed"))


func _on_Player_hit():
	$HUD.last_chance()


func new_game():
	GlobalVar.Sprite_name = "Asteroid"
	get_tree().call_group("mobs", "queue_free")
	score_local = 0
	$Player.start($StartPosition.position)
	$BossTimer1.start()
	$HUD.update_score(score_local)
	$Music.play()
	$MobTimer.start()
	$SpeedSpawnMobsTimer.start()
	$SpawnBonusTimer.start()
	$CoinTimer.start()
	$MobTimer.wait_time = 2
	GlobalVar.Number_of_Boss_flag = 1
	$MainMenuMusic.stop()
	Bridge.advertisement.show_banner()
	
	# Здесь, как тест, потом перенести в функцию вознаграждения после убийства босса1 _on_AfterBossCoinStorm_timeout
#	$BossTimer2.start()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.unit_offset = randf()
	#print(mob_spawn_location.global_position)
	var direction = mob_spawn_location.rotation + PI / 2
	randomize()
	direction += rand_range(-PI / 4, PI / 4)
	GlobalVar.mob_spawn_location_position = mob_spawn_location.global_position
	GlobalVar.mob_direction = direction
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_bonus_spawn_timer_timeout():
	var bonus = bonus_scene.instance()
	var bonus_spawn_location = get_node("MobPath/MobSpawnLocation")
	randomize()
	bonus_spawn_location.unit_offset = randf()
	var direction = bonus_spawn_location.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	bonus.position = bonus_spawn_location.global_position
	bonus.rotation = direction
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	bonus.linear_velocity = velocity.rotated(direction)
	add_child(bonus)

# SpeedSpawnMobsTimer ускорение появления астероидов
func _on_SpeedSpawnMobsTimer_timeout():
	# Ускорение появления врагов
	if ($MobTimer.wait_time > 0.5):
		$MobTimer.wait_time -= 0.05
	if (GlobalVar.mob_speed_var <= 2):
		GlobalVar.mob_speed_var += 0.02

func _on_player_bonus_pick_up():
	get_tree().call_group("bonus", "queue_free")
	Signals.emit_signal("polish_cow")
	GlobalVar.mob_wait_time_global = $MobTimer.wait_time
	$MobTimer.wait_time = 2
	GlobalVar.mob_speed_var = GlobalVar.mob_speed_var - GlobalVar.mob_speed_var * 0.5
	$Music.stream_paused = true
	$BonusPickMusic.play()
	$DurationBonusTimer.start()
	get_tree().call_group("mobs", "_bonus_activate")

func _on_duration_bonus_timer_timeout():
	GlobalVar.mob_speed_var = GlobalVar.mob_speed_constant
	$BonusPickMusic.stop()
	$Music.stream_paused = false
	$MobTimer.wait_time = GlobalVar.mob_wait_time_global
	Signals.emit_signal("asteroid_sprite")
	GlobalVar.Sprite_name = "Asteroid"
	
func _bonus_spawn_location(size_x, size_y):
	var indent_x = size_x * 0.1
	var indent_y = size_y * 0.1
	var position_bonux_x = rand_range(0 + indent_x,size_x - indent_x)
	var position_bonux_y = rand_range(0 + indent_y,size_y - indent_y)
	
	return [position_bonux_x,position_bonux_y]
	
func _on_boss_timer_1_timeout():
	_boss1_entired()
	$BossTimer1.stop()
	$BonusPickMusic.stop()
	$DurationBonusTimer.stop()
	get_tree().call_group("bonus", "queue_free")
	Signals.emit_signal("boss_entered_leave_mobs")
	$TimerShowBanner.start()

func _boss1_entired():
	Boss = Boss_scene1.instance()
	GlobalVar.Number_of_Boss_flag = 1
	$Music.stop()
	$BonusPickMusic.stop()
	$BossMusic1.play()
	$MobTimer.stop()
	$SpawnBonusTimer.stop()
	add_child(Boss)
	$LapkaDamageBossTimer.start()
	$CoinTimer.stop()
	
	
func _on_BossTimer2_timeout():
	_boss2_entired()
	$BossTimer2.stop()
	$BonusPickMusic.stop()
	$DurationBonusTimer.stop()
	get_tree().call_group("bonus", "queue_free")
	Signals.emit_signal("boss_entered_leave_mobs")
	$TimerShowBanner.start()
	
func _boss2_entired():
	Boss = Boss_scene2.instance()
	GlobalVar.Number_of_Boss_flag = 2
	$Music.stop()
	$BonusPickMusic.stop()
	$BossMusic1.play()
	$MobTimer.stop()
	$SpawnBonusTimer.stop()
	add_child(Boss)
	$LapkaDamageBossTimer.start()
	$CoinTimer.stop()
	
	
func _on_player_dog_damage():
	get_tree().call_group("dog_damage", "queue_free")
	if (GlobalVar.Number_of_Boss_flag == 1):
		GlobalVar.BossLifes -= 1
		Boss.get_node("BossPath").get_node("DogBoss1")._damage()
		$CatDoDamage.play()
		if (GlobalVar.BossLifes == 0):
			$BossMusic1.stop()
			$LapkaDamageBossTimer.stop()
	elif (GlobalVar.Number_of_Boss_flag == 2):
		GlobalVar.BossLifes2 -= 1
		Boss.get_node("Char_DogBoss2")._damage()
		$CatDoDamage.play()
		if (GlobalVar.BossLifes2 == 0):
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

# Функция для продолжения игры, после убийства босса
func _resume_game_after_boss():
	GlobalVar.Sprite_name = "Asteroid"
	Signals.emit_signal("boss_killed_return_mobs")
	$AfterBossCoinStorm.start()
	$CoinTimer.start()
	$CoinTimer.wait_time = 0.1
	$BossWinSound.play()


func _on_CoinTimer_timeout():
	var coin = coin_scene.instance()
	var coin_spawn_location = get_node("MobPath/MobSpawnLocation")
	randomize()
	coin_spawn_location.unit_offset = randf()
	var direction = coin_spawn_location.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	coin.position = coin_spawn_location.global_position
	coin.rotation = direction
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	coin.velocity = velocity.rotated(direction)
	add_child(coin)


func _on_Player_coin_up():
	$CoinSound.play()
	score_local += 1
	$HUD.update_score(score_local)


# Поток монет после смерти босса
func _on_AfterBossCoinStorm_timeout():
	$Music.play()
	$SpeedSpawnMobsTimer.start()
	$SpawnBonusTimer.start()
	$MobTimer.start()
	$CoinTimer.wait_time = 1.5
	$AfterBossCoinStorm.stop()
	GlobalVar.BossLifes = 3
	GlobalVar.BossLifes2 = 3
	if (GlobalVar.Number_of_Boss_flag == 1):
		$BossTimer2.start()
	elif (GlobalVar.Number_of_Boss_flag == 2):
		$BossTimer1.start()


func _on_TimerShowBanner_timeout():
	$TimerShowBanner.stop()
	Signals.emit_signal("show_banner")



