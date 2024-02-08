######################
### SPACE SHOOTER  ###
######################

extends Area2D


@export var initial_speed := 2
@export var shooting_period:float = 2
@export var current_health := 3
@export var color := Color(0.95, 0.25, 0.85)
@export var hit_color := Color(1.0, 1.0, 0.2)

@onready var bullets: CharBullet = %EnemyBullets
@onready var shoot_timer := %SBulletTimer
@onready var hit_timer := %HitTimer
@onready var sprite2d: Sprite2D = %Sprite2D
@onready var collision_shape2d: CollisionPolygon2D = $CollisionPolygon2D

var height_offset: float
var target: Vector2 
var rotation_velocity: float = 1
var max_rot_vel: float = 2
var Player: Area2D
var ready_to_shoot := false
@onready var smaterial: Material = %Sprite2D.material


func _ready():
	var offset := 50
	self.position.x = randi_range(offset, Manager.screen_width - offset)
	self.target = Vector2(
		self.position.x,
		randf_range(offset, Manager.screen_height - offset)
	)
	self.smaterial.set_shader_parameter("color", color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Player == null or Player.is_dead:
		return
	
	Enemy.physics_process(self)
	self.rotation += delta * self.rotation_velocity
	
	if self.position.y >= target.y - 2:
		if self.ready_to_shoot:
			return
		ready_to_shoot = true
		self.shoot_timer.start(self.shooting_period)
	
	self.position = self.position.lerp(target, delta * initial_speed)
	self.rotation_velocity = lerpf(
		self.rotation_velocity, max_rot_vel, self.position.y / target.y
	)


func _on_s_bullet_timer_timeout():
	if Player == null or Player.is_dead:
		return
	
	# 60 degrees
	var rot_offset := 1.0472
	for i in range(6):
		if i % 2 == 0:
			continue
		self.bullets.shoot(self.position, 
			Vector2.RIGHT.rotated(self.rotation + i * rot_offset))
	
	if not Player.is_dead:
		self.shoot_timer.start(self.shooting_period)


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	self.current_health = Enemy.on_body_shape_entered(body_rid, 1, self)


func _on_hit_timer_timeout():
	Enemy.hit_timeout(self)
