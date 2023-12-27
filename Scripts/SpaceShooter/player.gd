######################
### SPACE SHOOTER  ###
######################

extends Area2D

@export var SPEED := 300
@export var current_health = 5
@export var shooting_period := 0.5
@onready var bullets: CharBullet = %PlayerBullets
@onready var bullet_timer: Timer = %PBulletTimer
var can_shoot := true


func _physics_process(delta):
	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	self.position = SpaceShooterChar.move(
		self.position, input_direction, SPEED, delta
	)
	
	if Input.is_action_pressed("ui_accept") and self.can_shoot:
		self.bullets.shoot(self.position, Vector2.UP)
		self.can_shoot = false
		self.bullet_timer.start(self.shooting_period)


func take_damage(damage: int) -> void:
	self.current_health = SpaceShooterChar.take_damage(
		self.current_health, 
		damage, 
		func(): self.visible = false
	)


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	PhysicsServer2D.body_set_state(
		body_rid, PhysicsServer2D.BODY_STATE_SLEEPING, true
	)


func _on_p_bullet_timer_timeout():
	self.can_shoot = true
