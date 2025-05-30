extends CharacterBody2D

@export var score_value: int = 50
@export var speed: float = 50.0  
@export var gravity: float = 980.0  
@export var damage: int = 10  

@onready var animated_sprite = $AnimatedSprite2D
@onready var detection_area = $Area2D
@onready var score_system = get_node("/root/ScoreSystem")
@onready var left_limit = $LeftMarker2D.global_position.x
@onready var right_limit = $RightMarker2D.global_position.x

var direction: int = 1
var is_chasing: bool = false
var player: Node2D = null

func _ready():
	global_position.x = clamp(global_position.x, left_limit, right_limit)
	animated_sprite.play("walk")
	print("📍 Enemy Starting Position:", global_position)

func _physics_process(delta: float):
	velocity.y += gravity * delta
	
	if is_chasing and is_instance_valid(player):  
		var direction_to_player = (player.global_position - global_position).normalized()
		velocity.x = direction_to_player.x * speed
	else:
		velocity.x = direction * speed

	move_and_slide()

	animated_sprite.flip_h = (direction < 0)

	if abs(velocity.x) < 1:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("walk")

func _switch_direction():
	direction *= -1
	print("🔄 Switching Direction. Now moving:", "Left" if direction < 0 else "Right")


func _on_detection_area_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		player = body
		is_chasing = true

func _on_detection_area_body_exited(body: Node2D):
	if body == player:
		is_chasing = false
		player = null

func _on_enemy_body_entered(body: Node2D):
	print("💥 Enemy hit the player!")
	if body.has_method("take_damage"):
		body.take_damage(damage)
		animated_sprite.play("hit")
func die():
	print("☠️ Enemy Defeated!")
	if score_system.has_method("increase_score"):
		score_system.increase_score(score_value)
	queue_free()


func _on_collision_shape_2d_draw() -> void:
	pass


func _on_head_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("☠️ Enemy stomped by player!")
		if score_system.has_method("increase_score"):
			score_system.increase_score(score_value)
			body.bounce()
			die()
