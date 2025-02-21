extends CharacterBody2D

@export var direction_x = 1
@export var direction_y = 0
@export var zombie_type = "normal"
@export var speed = 100.0

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	animated_sprite.play(zombie_type)
	velocity = Vector2(direction_x, direction_y) * speed

	move_and_slide()
	
	if (velocity.x > 0):
		animated_sprite.scale.x = 1
	elif (velocity.x < 0):
		animated_sprite.scale.x = -1

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	direction_x *= -1
	direction_y *= -1
