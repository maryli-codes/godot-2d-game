extends Node2D

@onready var music_player = $MusicPlayer

func _ready():
	music_player.play()
	music_player.finished.connect(_on_music_finished)

func _on_music_finished():
	music_player.play()
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Level1.tscn")

func _on_high_score_pressed() -> void:
	get_tree().change_scene_to_file("res://Score.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
