extends Control

func _input(event):
	if event.is_action_pressed("pause") and GlobalVar.flag_pause_dont_work:
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state

func _on_PauseButton_pressed():
	if (GlobalVar.flag_pause_dont_work):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
