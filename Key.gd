extends Area2D

signal key_body_collected

@onready var sfx_player = $KeySound
@onready var trophy = $Trophy

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("🗝️ Key Collected!")
		key_body_collected.emit()
		queue_free()

		if sfx_player and sfx_player.stream:
			remove_child(sfx_player)
			get_parent().add_child(sfx_player)
			sfx_player.play()  

		queue_free()
