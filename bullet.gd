extends Area2D

@export var _speed: float = 500.0
@export var _damage: int = 10

var direction: Vector2 

func _ready():
	await get_tree().create_timer(3).timeout
	queue_free()

func setDirection(bullet_direction: Vector2) -> void:
	direction = bullet_direction
	rotation = direction.angle()

func _physics_process(_delta: float) -> void:
	global_position += direction * _speed * _delta
