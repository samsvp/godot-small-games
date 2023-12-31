######################
### SPACE SHOOTER  ###
######################

extends Area2D


@export var initial_speed := 2
@export var current_health = 6
@export var color := Color(0.95, 0.5, 0.5)
@export var hit_color := Color(1.0, 1.0, 0.2)

@onready var shoot_timer := %ShootTimer
@onready var hit_timer := %HitTimer
@onready var bullets: CharBullet = %EnemyBullets
@onready var sprite2d: Sprite2D = %Sprite2D
@onready var smaterial: Material = %Sprite2D.material
@onready var collision_shape2d: CollisionShape2D = $CollisionShape2D

var height_offset: float
var target: Vector2
var Player: Node2D


func _ready():
	self.position.x = randi_range(50, Manager.screen_width - 50)
	self.target = Vector2(self.position.x, Manager.screen_height / 2)
	self.height_offset = randf_range(-100, 100)
	self.smaterial.set_shader_parameter("color", color)
	self.shoot_timer.start(1)


func _physics_process(delta):
	Enemy.physics_process(self)
	if self.position.y > Manager.screen_height / 2 + height_offset:
		return
	
	self.position = self.position.lerp(target, delta * initial_speed)


func _on_shoot_timer_timeout():
	if Player == null or Player.is_dead:
		return
	
	var target = Player.position
	self.bullets.shoot(self.position, target - self.position)


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	self.current_health = Enemy.on_body_shape_entered(body_rid, 1, self)


func _on_hit_timer_timeout():
	Enemy.hit_timeout(self)
