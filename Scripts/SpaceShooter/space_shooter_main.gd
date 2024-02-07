extends Node2D

@export var basic_enemy_scene: PackedScene
@export var spin_enemy_scene: PackedScene
@export var kamikaze_enemy_scene: PackedScene
@export var shotgunner_enemy_scene: PackedScene

@onready var basic_enemy_timer := %BasicEnemyTimer
@onready var spin_enemy_timer := %RotatingEnemyTimer
@onready var kamikaze_enemy_timer := %KamikazeEnemyTimer
@onready var shotgunner_enemy_timer := %ShotgunnerEnemyTimer
@onready var Player := %Player
@onready var EnemiesNode := %Enemies

var current_enemies: Array[Area2D] = []
var wave_enemy_count := -1
var wave_index = 0
@onready var waves = [
	[{"enemy": basic_enemy_scene, "amount": 10, "min_t": 2, "max_t": 3}],
	
	[{"enemy": basic_enemy_scene, "amount": 20, "min_t": 2, "max_t": 3}],
	
	[{"enemy": basic_enemy_scene, "amount": 20, "min_t": 2, "max_t": 3}, 
	{"enemy": shotgunner_enemy_scene, "amount": 5}],
	
	[{"enemy": basic_enemy_scene, "amount": 30, "min_t": 2, "max_t": 3},
	{"enemy": shotgunner_enemy_scene, "amount": 10, "min_t": 3, "max_t": 4}],
	
	[{"enemy": basic_enemy_scene, "amount": 20, "min_t": 2, "max_t": 3},
	{"enemy": shotgunner_enemy_scene, "amount": 5, "min_t": 3, "max_t": 4},
	{"enemy": kamikaze_enemy_scene, "amount": 2, "min_t": 5, "max_t": 8}],
	
	[{"enemy": basic_enemy_scene, "amount": 25, "min_t": 2, "max_t": 3},
	{"enemy": shotgunner_enemy_scene, "amount": 8, "min_t": 3, "max_t": 4},
	{"enemy": kamikaze_enemy_scene, "amount": 5, "min_t": 5, "max_t": 8}],
	
	[{"enemy": basic_enemy_scene, "amount": 25, "min_t": 2, "max_t": 3},
	{"enemy": shotgunner_enemy_scene, "amount": 5, "min_t": 3, "max_t": 4},
	{"enemy": kamikaze_enemy_scene, "amount": 5, "min_t": 5, "max_t": 8},
	{"enemy": spin_enemy_scene, "amount": 2, "min_t": 5, "max_t": 8}],
	
	[{"enemy": basic_enemy_scene, "amount": 30, "min_t": 2, "max_t": 3},
	{"enemy": shotgunner_enemy_scene, "amount": 10, "min_t": 3, "max_t": 4},
	{"enemy": kamikaze_enemy_scene, "amount": 8, "min_t": 5, "max_t": 8},
	{"enemy": spin_enemy_scene, "amount": 5, "min_t": 5, "max_t": 8}],
]

# Called when the node enters the scene tree for the first time.
func _ready():
	self.spawn_wave()


func _process(delta):
	if current_enemies.size() != wave_enemy_count:
		return 
	
	# check if the current wave has finished
	var finished_wave := true
	for enemy in current_enemies:
		if is_instance_valid(enemy) and enemy.current_health > 0:
			finished_wave = false
			break
	if finished_wave:
		if self.wave_index < self.waves.size():
			wave_index += 1


# await makes this function a coroutine
func spawn_enemy_coroutine(pscene: PackedScene, amount: int,
				 min_t: float, max_t: float) -> void:
	var timer := Timer.new()
	add_child(timer)
	for i in range(amount):
		if Player.is_dead:
			return
	
		var enemy_scene = pscene.instantiate()
		enemy_scene.Player = Player
		EnemiesNode.add_child(enemy_scene)
		
		self.current_enemies.append(enemy_scene)
		
		var t = randf_range(min_t, max_t)
		timer.start(t)
		await timer.timeout
	timer.queue_free()


func spawn_wave():
	self.wave_enemy_count = 0
	var wave = self.waves[self.wave_index]
	for enemy_info in wave:
		self.spawn_enemy_coroutine(
			enemy_info["enemy"], enemy_info["amount"], 
			enemy_info["min_t"], enemy_info["max_t"]
		)
		self.wave_enemy_count += enemy_info["amount"]
