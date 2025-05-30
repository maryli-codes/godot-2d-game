extends Node2D

@onready var score_label = $ScoreLabel
@onready var back_button = $BackButton
@onready var music_player = $MusicPlayer

func _on_music_finished():
	music_player.play()

func _ready():
	update_score_label_2()
	back_button.pressed.connect(_on_back_pressed)
	music_player.play()
	music_player.finished.connect(_on_music_finished)

func update_score_label_2():
	var final_score = Global.score  
	score_label.text = "Your High Score: " + str(final_score)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
