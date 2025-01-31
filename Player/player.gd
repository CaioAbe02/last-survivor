extends CharacterBody2D
class_name Player

@export_category("Variables")
@export var _move_speed: float = 100.0

func handleInput():
	var _direction: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	velocity = _direction * _move_speed	
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$Gun.fire()

func updateAnimation():
	var player_position = $Player.global_position
	var mouse_position = get_viewport().get_mouse_position()
	
	if (mouse_position.x < player_position.x):
		$Player.scale.x = -1
	else:
		$Player.scale.x = 1
	
func _physics_process(_delta: float) -> void:
	handleInput()
	move_and_slide()
	updateAnimation()
