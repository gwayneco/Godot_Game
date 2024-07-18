extends CanvasLayer


signal start_game


func _ready():
	pass 

func _process(delta):
	pass

func show_message(text):
#	$Message.text = text
#	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	#$Message.text = "Ебаш"
#	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_message_timer_timeout():
	#$StartButton.hide()
	#start_game.emit()
	pass

func _on_StartButton_pressed():
#	$Message.hide()
	$StartButton.hide()
#	start_game.emit()
	emit_signal("start_game")
