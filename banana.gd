extends Area2D

signal collected

@onready var animated_sprite = $AnimatedSprite2D
var sfx_player

func _ready():
	if animated_sprite:
		animated_sprite.play("idle")
		
	sfx_player = get_node_or_null("AudioStreamPlayer2D")
	
	print("Banana Scene Tree:")
	print_tree()

	sfx_player = $AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  
		print("Banana touched by player!")  
		body.take_banana()  
		collected.emit()  

		visible = false  
		set_deferred("collision_layer", 0)

		if sfx_player and sfx_player.stream:
			sfx_player.play()
			await sfx_player.finished  

		queue_free()
