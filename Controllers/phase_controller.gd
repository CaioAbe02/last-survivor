extends Node2D

@onready var player_healthbar = $CanvasLayer/PlayerHealthbar
@onready var player_health_label = $CanvasLayer/LifeContainer/LifeLabel
@onready var player = $Player
@onready var enemy_spawner_controller = $CanvasLayer/EnemySpawnerController
@onready var wave_label = $CanvasLayer/WaveCenterContainer/WaveLabel
@onready var game_over_conatainer = $CanvasLayer/GameOverContainer

func _ready() -> void:
	player_healthbar.init_health(player._life)

func _on_player_player_took_damage() -> void:
	player_healthbar.health = player._life
	player_health_label.text = str(player._life)

func _on_enemy_spawner_controller_wave_ended() -> void:
	wave_label.text = "WAVE " + str(enemy_spawner_controller.wave)

func _on_player_player_died() -> void:
	game_over_conatainer.visible = true

func _on_restart_pressed() -> void:
	print("RENASCEU!")
	get_tree().change_scene_to_file("res://city.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
