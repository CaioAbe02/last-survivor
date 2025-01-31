extends Node2D

@export var _firerate: float = 0.1
@export var _magazine_capacity: int = 30
@export var _reload_timer: float = 1.0

const BULLET = preload("res://bullet.tscn")

var can_fire: bool = true
var bullet_count: int

func _ready() -> void:
	$FirerateTimer.wait_time = _firerate
	$ReloadTimer.wait_time = _reload_timer
	bullet_count = _magazine_capacity

func rifleRotation() -> Vector2:
	var rifle_pos = self.global_position
	var mouse_pos = get_global_mouse_position()
	var rifle_direction = (mouse_pos - rifle_pos).normalized()
	
	# Define a escala com base na direção
	if (mouse_pos.x < rifle_pos.x):
		self.scale.y = -1
	else:
		self.scale.y = 1
	
	look_at(mouse_pos)
	
	return rifle_direction

func fire() -> void:
	if bullet_count == 0 and !$ReloadTimer.is_stopped():  # Se já está recarregando, não faça nada
		return

	if bullet_count == 0:
		can_fire = false
		$ReloadTimer.start()
	
	if can_fire:
		can_fire = false
		bullet_count -= 1
		var bullet_node = BULLET.instantiate()
		var bullet_direction = rifleRotation()
		bullet_node.global_position = $Marker2D.global_position
		bullet_node.setDirection(bullet_direction)
		bullet_node._speed = 1000.0
		get_node("/root").add_child(bullet_node)
		$FirerateTimer.start()		

func _on_firerate_timer_timeout() -> void:
	can_fire = true

func _on_reload_timer_timeout() -> void:
	bullet_count = _magazine_capacity
	$ReloadTimer.stop()
	can_fire = true

func _physics_process(_delta: float) -> void:
	rifleRotation()
