######################
### SPACE SHOOTER  ###
######################

extends Area2D

@onready var bullets: CharBullet = %PlayerBullets
@onready var back_bullets: CharBullet = %BackBullets
@onready var tracker_bullets: CharBullet = %TrackerBullets
@onready var circular_bullets: CharBullet = %CircularBullets
@onready var bullet_timer: Timer = %PBulletTimer
@onready var back_bullet_timer: Timer = %BackBulletTimer
@onready var tracker_bullet_timer: Timer = %TrackerBulletTimer
@onready var circular_bullet_timer: Timer = %CircularBulletTimer
@onready var hit_timer: Timer = %HitPauseTimer

@export var EnemiesNode :Node2D
@export var speed := 300
@export var current_health = 5
@export var shooting_period := 0.5
@export var color := Color(0.5, 0.95, 0.5)
@export var hit_color := Color(1.0, 1.0, 1.0)

var can_shoot := true
var can_shoot_tracker := true
var can_shoot_circular := true
var can_shoot_back := true
var back_weapon_gotten := false
var tracker_weapon_gotten := false
var circular_weapon_gotten := false
var smaterial: Material


func _ready():
	self.smaterial = %Sprite2D.material
	self.smaterial.set_shader_parameter("color", color)


func _physics_process(delta):
	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	self.position = SpaceShooterChar.move(
		self.position, input_direction, speed, delta
	)
	
	if self.can_shoot:
		self.bullets.shoot(self.position, Vector2.UP)
		self.can_shoot = false
		self.bullet_timer.start(self.shooting_period)
	if self.tracker_weapon_gotten \
			and self.can_shoot_tracker and EnemiesNode != null:
		self.shoot_tracker_bullets()
		self.can_shoot_tracker = false
		self.tracker_bullet_timer.start(20 * self.shooting_period)
	if self.circular_weapon_gotten and self.can_shoot_circular:
		self.shoot_circular_bullets()
		self.can_shoot_circular = false
		self.circular_bullet_timer.start(12 * self.shooting_period)
	if self.back_weapon_gotten and self.can_shoot_back:
		self.shoot_back_bullets()
		self.can_shoot_back = false
		self.back_bullet_timer.start(5 * self.shooting_period)


func shoot_tracker_bullets():
	var target := Vector2.UP
	var min_dist := INF
	for enemy: Node2D in EnemiesNode.get_children():
		# enemy has already been defeated
		if enemy.bullets.stop == true:
			continue
			
		var dv = enemy.position - self.position
		var dist := dv.length_squared()
		# add a little randomness so that it doesn't always tracks 
		# the closest enemy
		if dist < min_dist and (target == Vector2.UP or randf() < 0.6):
			min_dist = dist
			target = dv
	
	for i in range(4):
		var speed_multiplier := randfn(1.0, 0.2)
		var dir_noise := Vector2(randfn(0.0, 30), randfn(0.0, 30))
		self.tracker_bullets.shoot(
			self.position, 
			target + dir_noise, 
			speed_multiplier)


func shoot_circular_bullets():
	# 60 degrees
	var rot_offset := 1.0472
	for i in range(6):
		self.circular_bullets.shoot(
			self.position, 
			Vector2.RIGHT.rotated(self.rotation + i * rot_offset))


func shoot_back_bullets():
	# 10 degrees
	var rot_offset := 0.174533
	for i in range(6):
		self.back_bullets.shoot(
			self.position, 
			Vector2(0.5, 1.0).normalized().rotated(self.rotation + i * rot_offset))


func take_damage(damage: int) -> void:
	self.current_health = SpaceShooterChar.take_damage(
		self,
		damage,
		func(): self.visible = false,
	)
	get_tree().paused = true


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	PhysicsServer2D.body_set_state(
		body_rid, PhysicsServer2D.BODY_STATE_SLEEPING, true
	)


func _on_p_bullet_timer_timeout():
	self.can_shoot = true

func _on_tracker_bullet_timer_timeout():
	self.can_shoot_tracker = true

func _on_circular_bullet_timer_timeout():
	self.can_shoot_circular = true

func _on_back_bullet_timer_timeout():
	self.can_shoot_back = true

func _on_area_entered(area):
	self.take_damage(1)


func _on_hit_pause_timer_timeout():
	get_tree().paused = false
	%Sprite2D.material.set_shader_parameter("color", color)
