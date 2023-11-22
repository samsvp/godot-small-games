######################
###      PONG      ###
######################
extends Area2D

var speed: float
var play_time: float
@export var min_speed := 240.0
@export var max_speed := 640.0
var direction: Vector2
var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
var outline_color: Vector4 
var initial_outline_color = Vector4(0.2, 0.3, 0.85, 1.0)
@onready var Character := %Character
@onready var sprite: Sprite2D = get_node("Ball")


func _ready():
	reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	play_time += delta
	self.position += self.direction * self.speed * delta
	# increase speed
	if speed < max_speed:
		speed = lerp(min_speed, max_speed, play_time ** 2 / 500)
	
	# checks if we hit the ceiling/flor and change y direction
	if self.position.y > self.screen_height - 16 or self.position.y < 16:
		self.direction.y = -self.direction.y

	if self.position.x > self.screen_width - 16 or self.position.x < 16:
		reset()


func reset():
	self.outline_color = self.initial_outline_color
	self.play_time = 0.0
	self.speed = self.min_speed
	self.position = Vector2(self.screen_width / 2, self.screen_height / 2)
	self.direction = get_random_initial_direction()


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
		self.direction.x = 1
		add_y_direction_noise()
		Character.set_outline(self.sprite, body.outline_color, 1.0)


func _on_area_entered(area: Area2D):
	if area.name.to_lower() == "enemy":
		self.direction.x = -1
		add_y_direction_noise()
		Character.set_outline(self.sprite, area.outline_color, 1.0)
