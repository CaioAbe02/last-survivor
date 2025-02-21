extends CharacterBody2D
class_name Player

@export_category("Variables")
@export var _move_speed: float = 100.0
@export var _life: int = 100
@export var dead: bool = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var gun = $Gun
@onready var hit_flash_animation_player = $HitFlashAnimationPlayer

var viewport = null

signal playerTookDamage
signal player_died

func takeDamage(damage: int):
	_life -= damage
	
	if _life <= 0:
		_life = 0
		dead = true
		animated_sprite.play("idle")
		player_died.emit()
	else:
		hit_flash_animation_player.play("hit_flash")
	playerTookDamage.emit()

func handleInput():
	var _direction: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	velocity = _direction * _move_speed
	if _direction:
		animated_sprite.play("running")
	else:
		animated_sprite.play("idle")
	
	viewport = get_viewport_rect().size
	position.x = clamp(position.x, 0 + 16, viewport.x)
	position.y = clamp(position.y, 0 + 48, viewport.y)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		gun.fire()
	
	if Input.is_action_pressed("gun_reload"):
		gun.reload()

func flipPlayer():
	var player_position = global_position
	var mouse_position = get_viewport().get_mouse_position()
	
	if mouse_position.x < player_position.x:
		animated_sprite.scale.x = -1
	else:
		animated_sprite.scale.x = 1
	
func _physics_process(_delta: float) -> void:
	if !dead:
		handleInput()
		move_and_slide()
		flipPlayer()
