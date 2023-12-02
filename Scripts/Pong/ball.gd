######################
###      PONG      ###
######################
extends Area2D

var speed: float
var play_time: float
@export var min_speed := 240.0
@export var max_speed := 500.0
var direction: Vector2
var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
var outline_color: Vector4 
var initial_outline_color = Vector4(0.2, 0.3, 0.85, 1.0)
var timer: Timer
@onready var Character := %Character
@onready var PongManager := %PongManager
@onready var sprite: Sprite2D = get_node("Ball")
@onready var Particle: GPUParticles2D = get_node("GPUParticles2D")
@onready var Explosion: GPUParticles2D = get_node("Explosion")


func _ready():
	self.timer = Timer.new()
	self.timer.connect("timeout", self._on_timer_timeout)
	self.timer.set_wait_time(2)
	self.timer.one_shot = true
	self.add_child(self.timer)
	self.reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if PongManager.has_game_finished:
		return
		
	self.play_time += delta
	self.position += self.direction * self.speed * delta
	# increase speed
	if self.speed <  self.max_speed and self.speed > 0.001:
		self.speed = lerp(self.min_speed, self.max_speed, self.play_time ** 2 / 500)
		self.Particle.speed_scale = 0.5 + 0.5 * self.speed / self.max_speed
		self.Particle.amount = 4 + int(6 * self.speed / self.max_speed)
	
	# checks if we hit the ceiling/flor and change y direction
	if (self.position.y > self.screen_height - 16 and self.direction.y > 0) or \
			(self.position.y < 16 and self.direction.y < 0):
		self.direction.y = -self.direction.y

	if self.position.x > self.screen_width - 16:
		PongManager.increment_player_score()
		self.reset()
		
	if self.position.x < 16:
		PongManager.increment_enemy_score()
		self.reset()


func reset():
	self.outline_color = self.initial_outline_color
	self.play_time = 0.0
	self.speed = 0
	self.position = Vector2(self.screen_width / 2, self.screen_height / 2)
	self.Particle.speed_scale = 0.5
	self.Particle.emitting = false
	self.Particle.amount = 4
	self.timer.start()


## Creates a random initial direction for the ball.
## To be used when the game starts or when someone scores a point
func get_random_initial_direction() -> Vector2:
	var r_dir := Vector2(0, 0)
	r_dir.x = 1 if randf() > 0.5 else -1
	r_dir.y = randfn(0, 0.1)
	return r_dir


## Used to add a small noise to the ball direction each time the player
## or the enemy hits the ball
func add_y_direction_noise():
	self.direction.y += randfn(0, 0.2)


func _on_body_entered(body: Node2D):
	if body.name.to_lower() == "player":
		self.change_direction(body, 1)


func _on_area_entered(area: Area2D):
	if area.name.to_lower() == "enemy":
		self.change_direction(area, -1)


func change_direction(node: Node2D, x_direction: int) -> void:
	self.direction.x = x_direction
	add_y_direction_noise()
	Character.set_outline(self.sprite, node.outline_color, 1.0)
	
	self.Explosion.restart()
	self.Explosion.process_material.color = node.outline_color
	self.Explosion.process_material.set(
		"direction", x_direction * Vector3(1, 0, 0)
	)
	
	self.Particle.process_material.set(
		"direction", x_direction * Vector3(1, 0, 0)
	)
	self.Particle.process_material.color = node.outline_color


func _on_timer_timeout():
	if PongManager.has_game_finished:
		return
	
	self.speed = self.min_speed
	self.direction = self.get_random_initial_direction()
	self.Particle.emitting = true
	self.Particle.process_material.set(
		"Direction", self.direction.x * Vector3(1, 0, 0)
	)
