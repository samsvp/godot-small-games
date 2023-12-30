extends Node2D

@export var basic_enemy_scene: PackedScene
@export var basic_enemy_max_count: int = 5
@export var spin_enemy_scene: PackedScene
@export var spin_enemy_max_count: int = 2

var basic_enemy_current_count: int = 0
var spin_enemy_current_count: int = 0

@onready var basic_enemy_timer := %BasicEnemyTimer
@onready var spin_enemy_timer := %RotatingEnemyTimer
@onready var Player := %Player
@onready var EnemiesNode := %Enemies


# Called when the node enters the scene tree for the first time.
func _ready():
	self.basic_enemy_timer.start(0.5)
	self.spin_enemy_timer.start(10)


func remove_basic_enemy() -> void:
	self.basic_enemy_current_count -= 1


func spawn_enemy(current_count: int, max_count: int, 
				 min_t: float, max_t: float, timer: Timer, 
				 pscene: PackedScene) -> int:
	var t = randf_range(min_t, max_t)
	if current_count >= max_count:
		timer.start(t)
		return current_count
	
	var enemy_scene = pscene.instantiate()
	enemy_scene.Player = Player
	EnemiesNode.add_child(enemy_scene)
	timer.start(t)
	return current_count + 1


func _on_basic_enemy_timer_timeout():
	self.basic_enemy_current_count = self.spawn_enemy(
		self.basic_enemy_current_count, self.basic_enemy_max_count,
		1.0, 2.0, self.basic_enemy_timer, self.basic_enemy_scene
	)


func _on_rotating_enemy_timer_timeout():
	self.spin_enemy_current_count = self.spawn_enemy(
		self.spin_enemy_current_count, self.spin_enemy_max_count,
		5.0, 8.0, self.spin_enemy_timer, self.spin_enemy_scene
	)
