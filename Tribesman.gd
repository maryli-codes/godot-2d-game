extends CharacterBody2D

@export var speed: float = 100.0
@export var gravity: float = 980.0
@export var patrol_distance: float = 100.0
@onready var sfx_player = $AudioStreamPlayer2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var detection_area = $Area2D
@onready var start_position: Vector2 = global_position

var direction: int = 1
var left_limit: float
var right_limit: float

func _ready():
	left_limit = start_position.x - patrol_distance
	right_limit = start_position.x + patrol_distance

	animated_sprite.play("walk")
	print("✅ Patrol Limits:", left_limit, right_limit)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta  

	velocity.x = direction * speed  

	move_and_slide()

	if global_position.x <= left_limit or global_position.x >= right_limit:
		_switch_direction()

func _switch_direction():
	direction *= -1
	animated_sprite.flip_h = !animated_sprite.flip_h

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("⚠️ Player touched the Tribesman! Game Over!")

		animated_sprite.play("hit")
		
		set_physics_process(false)

		if sfx_player and sfx_player.stream:
			sfx_player.play()
			await sfx_player.finished

		get_tree().change_scene_to_file("res://GameOver.tscn")
