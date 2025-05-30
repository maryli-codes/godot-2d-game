extends Control

@onready var retry_button = $VBoxContainer/Retry
@onready var menu_button = $VBoxContainer/MainMenu
@onready var gameover_sfx = $AudioStreamPlayer2D

func _ready():
	gameover_sfx.play()

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Level1.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
