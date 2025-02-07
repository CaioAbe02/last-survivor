extends Node2D

@export var normal_zombie_wave_1 = 5
var normal_zombie_wave_1_spawned = 0

@export var runner_zombie_wave_1 = 1
var runner_zombie_wave_1_spawned = 0

var wave = 1
const normal_zombie = preload("res://Enemies/normal_zombie.tscn")
const runner_zombie = preload("res://Enemies/runner_zombie.tscn")
const spawn_cooldown = 1
var spawners = ["SpawnerL", "SpawnerR", "SpawnerU", "SpawnerD"]

func _ready() -> void:
	$SpawnTimer.wait_time = spawn_cooldown
	$SpawnTimer.start()

func _on_spawn_timer_timeout() -> void:
	$SpawnTimer.stop()
	
	if (wave == 1):
		if (normal_zombie_wave_1_spawned != normal_zombie_wave_1):
			normal_zombie_wave_1_spawned += 1
			for spawner in spawners:
				var normal_zombie_node = normal_zombie.instantiate()
				get_node(spawner).add_child(normal_zombie_node)
		elif (runner_zombie_wave_1_spawned != runner_zombie_wave_1):
			runner_zombie_wave_1_spawned += 1
			for spawner in spawners:
				var runner_zombie_node = runner_zombie.instantiate()
				get_node(spawner).add_child((runner_zombie_node))
	$SpawnTimer.start()
