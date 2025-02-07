extends CharacterBody2D

@export_category("Variables")
@export var _move_speed: float = 100.0
@export var _life: int = 100

var player = null
var direction = Vector2(1, 0)

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
func takeDamage(damage: int) -> void:
	_life -= damage
	
	if (_life <= 0):
		queue_free()

func moveToPlayer() -> void:
	if (player):
		direction = (player.global_position - global_position).normalized()
		velocity = direction * _move_speed
			
func updateAnimation() -> void:
	if (direction.x > 0):
		$Sprite.scale.x = 1
	elif (direction.x < 0):
		$Sprite.scale.x = -1

func _physics_process(_delta: float) -> void:
	moveToPlayer()
	move_and_slide()
	updateAnimation()
