######################
###      PONG      ###
######################
extends Area2D

@export var SPEED = 250.0
@export_range(0.0, 1.0) var tracking_pos = 0.5

const paddle_size = 64
var outline_color := Color(0.8, 0.0, 0.85, 1.0)
@onready var Ball := %Ball
@onready var Character = %Character

func _ready():
	var paddle: Sprite2D = get_node("Paddle")
	Character.set_outline(paddle, outline_color)
	self.position = Vector2(0.9 * Manager.screen_width, Manager.screen_height / 2)


func _process(delta: float):
	follow_ball(delta)


func follow_ball(delta: float):
	const eps := 10.0
	var ball_position = Ball.position
	if ball_position.x < self.tracking_pos * Manager.screen_width:
		return
		
	if Ball.position.y > self.position.y + eps:
		self.position.y += SPEED * delta
	elif Ball.position.y < self.position.y - eps:
		self.position.y -= SPEED * delta
	self.position.y = Character.clamp_y(self.position.y, self.paddle_size)


func reset():
	self.position = Character.reset(self.position)

