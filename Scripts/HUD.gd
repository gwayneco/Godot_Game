extends CanvasLayer

var device

signal start_game


func _ready():
	$Tutorial/AsteroidTutorial/EscapeAsteroidsAnimation.play("default")
	$Tutorial/CoinsTutorial/CollectCoinsAnimation.play("default")
	$Tutorial/BossTutorial/KillBosesAnimation.play("default")
	$Tutorial/CollectLapka/KillBosesAnimation.play("default")
	device = OS.get_model_name()
	$"Virtual joystick".hide()
	$GameOver.hide()
	$LangSelector.show()
	$Tutorial.hide()
	$StartButton.hide()

func _process(delta):
	if (Input.is_action_pressed("ui_accept")):
		$StartButton.hide()
		emit_signal("start_game")
		$Tutorial.hide()
#	print(get_viewport().get_mouse_position())

func show_game_over():
	$GameOver.show()
	$MessageTimer.start()
	# Make a one-shot timer and wait for it to finish.
	$StartButton.show()
	if (get_tree().root.get_child(0).has_node('res://joystick/virtual_joystick.tscn')):
		$"Virtual joystick".hide()


func update_score(score):
	$ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	$Tutorial/AsteroidTutorial/EscapeAsteroidsAnimation.stop()
	$Tutorial/CoinsTutorial/CollectCoinsAnimation.stop()
	$Tutorial/BossTutorial/KillBosesAnimation.stop()
	$Tutorial/CollectLapka/KillBosesAnimation.stop()
	$GameOver.hide()
	$StartButton.hide()
	$Tutorial.hide()
	if (device != "GenericDevice"):
		$"Virtual joystick".show()
	elif (device == "GenericDevice" and get_tree().root.get_child(0).has_node('res://joystick/virtual_joystick.tscn')):
		$"Virtual joystick".queue_free()
	emit_signal("start_game")
	$MessageTimer.stop()
		

func _on_MessageTimer_timeout():
	$MessageTimer.stop()
	$GameOver.hide()
	$Tutorial.show()
	$Tutorial/AsteroidTutorial/EscapeAsteroidsAnimation.play("default")
	$Tutorial/CoinsTutorial/CollectCoinsAnimation.play("default")
	$Tutorial/BossTutorial/KillBosesAnimation.play("default")
	$Tutorial/CollectLapka/KillBosesAnimation.play("default")

func _on_SelectEnglish_pressed():
	$Tutorial.show()
	$StartButton.show()
	$LangSelector.hide()
	TranslationServer.set_locale("en")

func _on_SelectRussian_pressed():
	$Tutorial.show()
	$StartButton.show()
	$LangSelector.hide()
	TranslationServer.set_locale("ru")
