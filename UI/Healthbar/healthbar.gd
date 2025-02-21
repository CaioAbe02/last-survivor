extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

var health = 0 : set = _set_health
var destroy = false

func _set_health(new_health) -> void:
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0 && destroy:
		queue_free()
		
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health

func init_health(_health, _destroy = false) -> void:
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health


func _on_timer_timeout() -> void:
	damage_bar.value = health
