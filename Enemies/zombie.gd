extends CharacterBody2D

signal zombie_died

@export_category("Variables")
@export var _move_speed: int = 100
@export var _life: int = 100
@export var _damage: int = 10
@export var player: Node2D = null

@onready var navigation_agent = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var hit_flash_animation_player = $HitFlashAnimationPlayer
@onready var blood_particles = $BloodParticles

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	call_deferred("enemy_setup")
	
func enemy_setup() -> void:
	await get_tree().physics_frame
	if player:
		navigation_agent.target_position = player.global_position
	
func takeDamage(damage: int) -> void:
	_life -= damage
	hit_flash_animation_player.play("hit_flash")
	blood_particles.emitting = true
	
	if (_life <= 0):
		zombie_died.emit()
		queue_free()

func moveToPlayer() -> void:
	if player:
		navigation_agent.target_position = player.global_position
	if navigation_agent.is_navigation_finished():
		return
		
	var current_enemy_pos = global_position
	var next_path_pos = navigation_agent.get_next_path_position()
	var new_velocity = current_enemy_pos.direction_to(next_path_pos) * _move_speed
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
			
func updateAnimation() -> void:
	if (velocity.x > 0):
		animated_sprite.scale.x = 1
	elif (velocity.x < 0):
		animated_sprite.scale.x = -1

func _physics_process(_delta: float) -> void:
	moveToPlayer()
	move_and_slide()
	updateAnimation()

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity

func _on_hitbox_body_entered(_body: Node2D) -> void:
	print("OUCH -", _damage)
	player.takeDamage(_damage)
