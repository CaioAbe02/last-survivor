extends Container

signal wave_ended

@export var normal_zombie_wave_spawns = [4, 0, 4, 0, 4]
var normal_zombie_spawned = 0

@export var runner_zombie_wave_spawns = [0, 3, 3, 0, 3]
var runner_zombie_spawned = 0

@export var strong_zombie_wave_spawns = [0, 0, 0, 3, 2]
var strong_zombie_spawned = 0

@export var normal_zombie_vel: int = 100
@export var normal_zombie_life: int = 100
@export var normal_zombie_damage: int = 10

@export var runner_zombie_vel: int = 175
@export var runner_zombie_life: int = 50
@export var runner_zombie_damage: int = 15

@export var strong_zombie_vel: int = 75
@export var strong_zombie_life: int = 200
@export var strong_zombie_damage: int = 25

var wave = 1
var wave_started = false
var all_enemies_spawned = false
var fat_zombie_spawned = false
var total_enemies = 0
const zombie = preload("res://Enemies/zombie.tscn")
const fat_zombie = preload("res://Enemies/fat_zombie.tscn")
const spawn_cooldown = 1

@onready var spawners = [$SpawnerU, $SpawnerL, $SpawnerR, $SpawnerD]
@onready var wave_start_timer = $WaveStartTimer

func _ready() -> void:
	$SpawnTimer.wait_time = spawn_cooldown
	$SpawnTimer.start()
	wave_start_timer.start()

func _on_zombie_died() -> void:
	total_enemies -= 1
	
	if all_enemies_spawned && total_enemies == 0:
		wave += 1
		wave_started = false
		normal_zombie_spawned = 0
		runner_zombie_spawned = 0
		strong_zombie_spawned = 0
		fat_zombie_spawned = false
		wave_start_timer.start()
		wave_ended.emit()

func spawn_zombie(_vel, _life, _damage, _walk_animation) -> void:
	for spawner in spawners:
		total_enemies += 1
		var zombie_node = zombie.instantiate()
		zombie_node.connect("zombie_died", _on_zombie_died)
		zombie_node._move_speed = _vel
		zombie_node.get_node("NavigationAgent2D").set_max_speed(_vel)
		zombie_node._life = _life
		zombie_node._damage = _damage
		zombie_node.get_node("AnimatedSprite2D").play(_walk_animation)
		zombie_node.position = spawner.position
		get_tree().get_root().get_node("City").add_child(zombie_node)

func spawn_fat_zombie() -> void:
	var fat_zombie_node = fat_zombie.instantiate()
	fat_zombie_node.position = spawners[0].position
	get_tree().get_root().get_node("City").add_child(fat_zombie_node)
	
func spawn_zombies() -> void:
	if wave <= normal_zombie_wave_spawns.size():
		if (normal_zombie_spawned != normal_zombie_wave_spawns[wave - 1]):
			normal_zombie_spawned += 1
			spawn_zombie(normal_zombie_vel, normal_zombie_life, normal_zombie_damage, "normal_walking")
		elif (runner_zombie_spawned != runner_zombie_wave_spawns[wave - 1]):
			runner_zombie_spawned += 1
			spawn_zombie(runner_zombie_vel, runner_zombie_life, runner_zombie_damage, "runner_walking")
		elif (strong_zombie_spawned != strong_zombie_wave_spawns[wave - 1]):
			strong_zombie_spawned += 1
			spawn_zombie(strong_zombie_vel, strong_zombie_life, strong_zombie_damage, "strong_walking")
	else:
		if wave % 6 == 0 && !fat_zombie_spawned:
			$SpawnTimer.wait_time = 3
			spawn_fat_zombie()
			fat_zombie_spawned = true
		else:
			$SpawnTimer.wait_time = spawn_cooldown
		
		if (normal_zombie_spawned != normal_zombie_wave_spawns[normal_zombie_wave_spawns.size() - 1]):
			normal_zombie_spawned += 1
			spawn_zombie(normal_zombie_vel, normal_zombie_life, normal_zombie_damage, "normal_walking")
		elif (runner_zombie_spawned != runner_zombie_wave_spawns[normal_zombie_wave_spawns.size() - 1]):
			runner_zombie_spawned += 1
			spawn_zombie(runner_zombie_vel, runner_zombie_life, runner_zombie_damage, "runner_walking")
		elif (strong_zombie_spawned != strong_zombie_wave_spawns[normal_zombie_wave_spawns.size() - 1]):
			strong_zombie_spawned += 1
			spawn_zombie(strong_zombie_vel, strong_zombie_life, strong_zombie_damage, "strong_walking")
		
	all_enemies_spawned = true
	
func _on_spawn_timer_timeout() -> void:
	$SpawnTimer.stop()
	if wave_started:
		spawn_zombies()
	$SpawnTimer.start()

func _on_wave_start_timer_timeout() -> void:
	wave_started = true
