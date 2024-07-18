extends CanvasLayer

signal return_game_after_interstitial
var flag_dont_show_after_for_olya = 0
var counter = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("show_banner", self, "_show_warning")
	# Отслеживать изменение состояния можно подключившись к сигналу
	Bridge.advertisement.connect("interstitial_state_changed", self, "_on_interstitial_state_changed")


func _on_interstitial_state_changed(state):
	print(state)
	if (state == "closed" or state == "failed"):
		print(state)
		if (flag_dont_show_after_for_olya):
			emit_signal("return_game_after_interstitial")
			flag_dont_show_after_for_olya = 0


func _show_warning():
	$WarningText.show()
	GlobalVar.flag_pause_dont_work = false
	get_tree().paused = true
	visible = true
	$Countdown.start()
	$TimerLabel.text = str(counter)


func _on_Countdown_timeout():
	if (counter >= 1):
		$TimerLabel.text = str(counter)
		counter -= 1
	else:
		counter = 2
		$Countdown.stop()
		flag_dont_show_after_for_olya = 1
		Bridge.advertisement.show_interstitial(false)
		$WarningText.hide()
