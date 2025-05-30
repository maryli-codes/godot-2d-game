extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	visible = false
	set_deferred("collision_layer", 0)

func _on_body_entered(body):
	print("🏆 Trophy touched by:", body.name)

	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://YouWin.tscn")
		
func _on_key_collected() -> void:
	print("🔓 Trophy unlocked!")
	visible = true
	set_deferred("collision_layer", 1)

func unlock():
	print("🔓 Trophy unlocked!")  
	visible = true  
	set_deferred("collision_layer", 1)  
