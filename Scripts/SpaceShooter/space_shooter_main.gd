extends Node2D

@export var basic_enemy_scene: PackedScene
@export var spin_enemy_scene: PackedScene
@export var kamikaze_enemy_scene: PackedScene

@onready var basic_enemy_timer := %BasicEnemyTimer
@onready var spin_enemy_timer := %RotatingEnemyTimer
@onready var kamikaze_enemy_timer := %KamikazeEnemyTimer
@onready var Player := %Player
@onready var EnemiesNode := %Enemies


# Called when the node enters the scene tree for the first time.
func _ready():
	self.basic_enemy_timer.start(0.5)
	self.spin_enemy_timer.start(10)
	self.kamikaze_enemy_timer.start(0.5)


func remove_basic_enemy() -> void:
	self.basic_enemy_current_count -= 1


func spawn_enemy(min_t: float, max_t: float, timer: Timer, 
				 pscene: PackedScene) -> void:
	var t = randf_range(min_t, max_t)
	var enemy_scene = pscene.instantiate()
	enemy_scene.Player = Player
	EnemiesNode.add_child(enemy_scene)
	timer.start(t)


func _on_basic_enemy_timer_timeout():
	self.spawn_enemy(
		2.0, 3.0, self.basic_enemy_timer, self.basic_enemy_scene
	)


func _on_rotating_enemy_timer_timeout():
	self.spawn_enemy(
		8.0, 12.0, self.spin_enemy_timer, self.spin_enemy_scene
	)


func _on_kamikaze_enemy_timer_timeout():
	self.spawn_enemy(
		6.0, 10.0, self.kamikaze_enemy_timer, self.kamikaze_enemy_scene
	)
