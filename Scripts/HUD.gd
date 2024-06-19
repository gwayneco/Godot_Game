extends CanvasLayer

var device
var prev_state
var ad_rewarded = false
var game_can_started = false

signal start_game
signal return_cat
signal set_score_to_leaderboard


func _ready():
	Bridge.advertisement.connect("rewarded_state_changed", self, "_on_rewarded_state_changed")
	$Tutorial/AsteroidTutorial/EscapeAsteroidsAnimation.play("default")
	$Tutorial/CoinsTutorial/CollectCoinsAnimation.play("default")
	$Tutorial/BossTutorial/KillBosesAnimation.play("default")
	$Tutorial/CollectLapka/KillBosesAnimation.play("default")
	device = Bridge.device.type
	$"Virtual joystick".hide()
	$LangSelector.show()
	$Tutorial.hide()
	$StartButton.hide()
	$PauseLayer/PauseButton.modulate.a8 = 100

func _process(delta):
	if (Input.is_action_pressed("ui_accept") and game_can_started):
		$StartButton.hide()
		emit_signal("start_game")
		$Tutorial.hide()
		game_can_started = false

func show_game_over():
	$StartButton.show()
	if (device != "desktop"):
		if ($"Virtual joystick".is_inside_tree()):
			$"Virtual joystick".hide()
	$GameOverDisplay.hide()
	$Tutorial.show()
	$Tutorial/AsteroidTutorial/EscapeAsteroidsAnimation.play("default")
	$Tutorial/CoinsTutorial/CollectCoinsAnimation.play("default")
	$Tutorial/BossTutorial/KillBosesAnimation.play("default")
	$Tutorial/CollectLapka/KillBosesAnimation.play("default")
	Signals.emit_signal("from_hud_gameover")
	GlobalVar.flag_pause_dont_work = not GlobalVar.flag_pause_dont_work
	game_can_started = true


func last_chance():
	$DeathSound.play()
	$GameOverDisplay.show()
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	GlobalVar.flag_pause_dont_work = not GlobalVar.flag_pause_dont_work
	emit_signal("set_score_to_leaderboard")
	


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed():
	$Tutorial/AsteroidTutorial/EscapeAsteroidsAnimation.stop()
	$Tutorial/CoinsTutorial/CollectCoinsAnimation.stop()
	$Tutorial/BossTutorial/KillBosesAnimation.stop()
	$Tutorial/CollectLapka/KillBosesAnimation.stop()
	$GameOverDisplay.hide()
	$StartButton.hide()
	$Tutorial.hide()
	if (device != "desktop"):
		$"Virtual joystick".rect_position = Vector2(86,833)
		$"Virtual joystick".show()
	elif (device == "desktop" and has_node("Virtual joystick")):
		$"Virtual joystick".queue_free()
	emit_signal("start_game")
	game_can_started = false

	
func _on_SelectEnglish_pressed():
	$Tutorial.show()
	$StartButton.show()
	$LangSelector.hide()
	TranslationServer.set_locale("en")
	game_can_started = true


func _on_SelectRussian_pressed():
	$Tutorial.show()
	$StartButton.show()
	$LangSelector.hide()
	TranslationServer.set_locale("ru")
	game_can_started = true


func _on_ReturnLife_pressed():
	Bridge.advertisement.show_rewarded()
	$DeathSound.stop()


func _on_ReturnMenu_pressed():
	$DeathSound.stop()
	show_game_over()
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	
func _on_rewarded_state_changed(state):
	if (state == "rewarded"):
		prev_state = str(state)
	elif (state == "closed" and prev_state == "rewarded"):
		_return_game()
	elif ((state == "closed" or state == "failed") and prev_state != "rewarded"):
		prev_state = str(state)
		$GameOverDisplay/ErrorAdShow.show()
	else:
		prev_state = str(state)


func _return_game():
	$AfterPause.show()
	$GameOverDisplay.hide()
	emit_signal("return_cat")


func _on_Button_pressed():
	$GameOverDisplay/ErrorAdShow.hide()
	if (has_node("Virtual joystick")):
		$"Virtual joystick"._reset()
	$AfterPause.hide()
	GlobalVar.flag_pause_dont_work = true
	get_tree().paused = false


func _on_BannerWarning_return_game_after_interstitial():
	get_tree().paused = true
#	print("after pause show")
	$BannerWarning.hide()
	$AfterPause.show()
