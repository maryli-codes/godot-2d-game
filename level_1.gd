extends Node2D

@onready var score_label = $HUD/ScoreLabel  # Ensure this path is correct
@onready var music_player = $MusicPlayer  # Reference to AudioStreamPlayer
@onready var sfx_player = $"/root/Level1/Banana/AudioStreamPlayer"
@onready var trophy = $Trophy  # Make sure trophy exists
@onready var hut_trigger = $"/root/Level1/HutTrigger"  # Make sure this path is correct!
@onready var tribesman = $"/root/Level1/Tribesman"  # Reference the Tribesman node


func _ready():
	update_score_label()
	music_player.play()
	music_player.finished.connect(_on_music_finished)  # Restart when finished
	
	trophy.visible = false  # Hide trophy at the start
	if hut_trigger:
		hut_trigger.connect("body_entered", Callable(self, "_on_hut_entered"))
	else:
		print("❌ ERROR: HutTrigger not found!")

func _on_hut_entered(body):
	if body.is_in_group("player"):  # Check if it's the player
		print("🚨 Player entered the hut! Telling Tribesman to chase!")
	tribesman.start_chasing()  # Call function in Tribesman

func _on_music_finished():
	music_player.play()  # Restart the music
	
func update_score_label():
	print("Updating score label: ", Global.score)  # Debugging line
	if score_label:
		score_label.text = "Score: " + str(Global.score)

func _on_banana_collected():
	Global.score += 1  # Update the global score
	print("Banana collected! New score:", Global.score)  # Debugging
	update_score_label()  # Update score label
	
func _on_key_collected():
	print("Key collected! Trophy unlocked!")
	trophy.visible = true  # Show the trophy

func _on_trophy_level_completed():
	print("Level Completed! 🎉 Moving to main menu...")  # Debugging  
	await get_tree().create_timer(1.0).timeout  # Small delay  
	get_tree().change_scene_to_file("res://YouWin.tscn")  # Change scene  


func _on_hut_trigger_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
