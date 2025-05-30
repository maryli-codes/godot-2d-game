extends Node2D

@onready var score_label = $Player/Camera2D/HUD_Canvas/HUD/VBoxContainer/ScoreLabel
@onready var music_player = $MusicPlayer
@onready var trophy = $Trophy
@onready var tribesman = $Tribesman
@onready var hud = $Player/Camera2D/HUD_Canvas/HUD
@onready var player = $Player
@onready var label = $Player/Camera2D/HUD_Canvas/HUD/GetTheKey
@onready var key = $Key

var time_left = 120

func _ready():
	music_player.play()	
	trophy.visible = false
	
	hud.update_health(player.health)
	hud.update_score(Global.score)
	hud.update_time(time_left)

	label.text = "Get the Key"
		
func _process(delta):
	if get_tree().paused:
		return
	
	time_left -= delta
	hud.update_time(int(time_left))
	
	if time_left <= 0:
		get_tree().change_scene_to_file("res://GameOver.tscn")

func pause_pressed(is_paused):
	print("Game Paused:", is_paused)
	get_tree().paused = is_paused

func _finished():
	music_player.play()

func health_changed(value: int):
	hud.update_health(value)

func score_changed(value):
	hud.update_score(value)

func _on_trophy_level_completed():
	print("Level Completed! 🎉 Moving to main menu...")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://YouWin.tscn")


func _on_player_ready() -> void:
	pass

func _on_key_body_collected():
	print("Key collected! Trophy unlocked!")
	trophy.visible = true
	label.text = "Find the Trophy"


func _on_http_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	print("✅ Server response: ", response_text)
	if response_code == 200:
		print("🎉 Score successfully updated!")
	else:
		print("❌ Server error: ", response_code)
