extends CharacterBody2D

@export var max_health: int = 100
var health: int
var last_y_position: float
var falling_start_y: float
var is_falling: bool = false

signal score_changed(value: int)
signal health_changed(new_health: int)

var score = 0

var current_health: int

@export var fall_damage_threshold: float = -10.0
@export var fall_damage_multiplier: int = 5


func _ready():
	health = max_health
	last_y_position = global_transform.origin.y
	update_health_bar()

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_JUMPS = 2  

var jumps_left = MAX_JUMPS
var gravity = ProjectSettings.get("physics/2d/default_gravity")  

@onready var animated_sprite = $AnimatedSprite2D  
@onready var health_bar = $HUD/HealthBar


@onready var jump_sound = $JumpSound
@onready var run_sound = $RunSound
@onready var hit_sound = $HitSound
@onready var damage_sound = $DamageSound
@onready var death_sound = $DeathSound
@onready var eat_sound = $EatSound

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta  
	else:
		jumps_left = MAX_JUMPS

	if Input.is_action_just_pressed("ui_up") and jumps_left > 0:
		if jumps_left == MAX_JUMPS:
			animated_sprite.play("jump")
		elif jumps_left == 1:
			animated_sprite.play("double_jump")
			jump_sound.play()

		velocity.y = JUMP_VELOCITY
		jumps_left -= 1  

	# Handle movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0  
		if is_on_floor():  
			animated_sprite.play("run")
			if not run_sound.playing:
				run_sound.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			animated_sprite.play("idle")  
			run_sound.stop()
		
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var collider = collision.get_collider()
	
		if collider and collider.is_in_group("Enemy"):
			take_damage(10)
			print("💥 Player hit by enemy!")
	
	detect_fall_damage()

	move_and_slide()

func detect_fall_damage():
	var velocity_y = velocity.y
	
	# START falling when moving downward
	if velocity_y > 0 and not is_falling:
		is_falling = true
		falling_start_y = global_transform.origin.y  # Save height when fall starts
	
	# STOP falling when we land on the floor
	elif velocity_y == 0 and is_falling and is_on_floor():
		is_falling = false
		var fall_distance = falling_start_y - global_transform.origin.y
		
		# ✅ Only apply fall damage if the player was actually falling down
		if fall_distance > 3.0:
			apply_fall_damage(fall_distance)

func apply_fall_damage(fall_distance: float):
	if fall_distance < 3.0:  
		return  # No damage for small falls
	
	var base_damage = (fall_distance - 3.0) * fall_damage_multiplier
	var damage = min(base_damage, 50)
	
	health -= damage
	update_health_bar()
	
		# ✅ Play "hurt" animation
	if animated_sprite:
		animated_sprite.play("hurt")
		await get_tree().create_timer(0.5).timeout  # Wait 0.5 sec before going back to normal
		animated_sprite.play("idle")
		
	print("Took", damage, "fall damage!")
	
	if health <= 0:
		get_tree().change_scene_to_file("res://GameOver.tscn")

func update_health_bar():
	if health_bar:
		health_bar.value = health
		
func take_damage(amount: int):
	health -= amount
	health_changed.emit(health)
	if health <= 0:	
		if death_sound and death_sound.stream:
			death_sound.play()
			await death_sound.finished
			get_tree().change_scene_to_file("res://GameOver.tscn")

func add_score(points: int):
	score += points
	score_changed.emit(score)
	
func take_banana():
	animated_sprite.play("eat")
	eat_sound.play()

func hit_by_enemy():
	velocity = Vector2.ZERO
	animated_sprite.play("hit")  
	hit_sound.play()

func change_health(amount: int):
	health = max(0, health + amount)
	emit_signal("health_changed", health)
	if health_bar:
		health_bar.value = health
		if health <= 30:
			health_bar.modulate = Color(1, 0, 0)
		else:
			health_bar.modulate = Color(1, 1, 1)
