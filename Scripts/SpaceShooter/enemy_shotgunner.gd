extends Area2D

@export var shooting_period := 1.0
@export var current_health := 3
@export var speed: float = 150
@export var color := Color(0.95, 0.5, 0.5)
@export var hit_color := Color(1.0, 1.0, 0.2)

@onready var shoot_timer := %ShootTimer
@onready var hit_timer := %HitTimer
@onready var bullets: CharBullet = %EnemyBullets
@onready var sprite2d: Sprite2D = %Sprite2D
@onready var smaterial: Material = %Sprite2D.material
@onready var collision_shape2d:CollisionPolygon2D = $CollisionPolygon2D

var radius_offset: float
var Player: Node2D
var is_shooting := false

# Called when the node enters the scene tree for the first time.
func _ready():
	var offset:float = 0.03 * Vector2(Manager.screen_height, 
							   Manager.screen_width).length_squared()
	self.radius_offset = randfn(offset, 0.1 * offset)
	self.smaterial.set_shader_parameter("color", color)
	self.position = Enemy.spawn_location()


func _physics_process(delta):
	if Player == null or Player.is_dead:
		return
	
	Enemy.physics_process(self)
	
	var target := Player.position - self.position
	var t_length = target.length_squared()
	self.rotation = SpaceShooterChar.look_towards(target, self, delta)
	if self.is_shooting:
		return
	if t_length > radius_offset:
		self.position = SpaceShooterChar.move(
			self.position, target, speed, delta
		)
	elif t_length < 0.8 * radius_offset:
		self.position = SpaceShooterChar.move(
			self.position, -target, speed, delta
		)
	else:
		self.shoot_timer.start(self.shooting_period)
		self.is_shooting = true


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	self.current_health = Enemy.on_body_shape_entered(body_rid, 1, self)


func _on_shoot_timer_timeout():
	if Player == null or Player.is_dead:
		return
	
	var target := Vector2(0.5, 1.0).normalized()
	var rot_offset := 0.174533 * 2 # 20 degrees
	for i in range(6):
		self.bullets.shoot(
			self.position, 
			target.rotated(self.rotation + i * rot_offset))
	
	self.is_shooting = false


func _on_hit_timer_timeout():
	Enemy.hit_timeout(self)
