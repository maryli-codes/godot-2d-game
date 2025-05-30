extends Control

@onready var timer_label = $VBoxContainer/TimerLabel
@onready var score_label = $VBoxContainer/ScoreLabel
@onready var health_bar = $HealthBar
@onready var pause_button = $PauseButton
@onready var pause_symbol = $PauseSymbol

signal pause_pressed(is_paused)

func update_health(new_health: int) -> void:
	print("Updated health:", new_health)
	$HealthBar.value = new_health

func update_score(value: int):
	if score_label:
		print("✅ HUD Score Updated: ", value)
		score_label.text = "Score: " + str(value)

func update_time(time: int):
	if timer_label:
		timer_label.text = "Time: " + str(time)

func _on_pause_pressed():
	if get_tree().paused:
		get_tree().paused = false
		pause_symbol.visible = false
		pause_button.text = "Pause"
		pause_button.modulate = Color(1, 1, 1)
	else:
		get_tree().paused = true
		pause_symbol.visible = true
		pause_button.text = "Unpause"
		pause_button.modulate = Color(1, 0, 0)

	pause_pressed.emit(get_tree().paused)
