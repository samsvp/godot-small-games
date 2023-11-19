######################
###      PONG      ###
######################
extends Area2D

@export var SPEED = 250.0
@export_range(0.0, 1.0) var tracking_pos = 0.5

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
const paddle_size = 64

func _ready():
	self.position = Vector2(0.9 * self.screen_width, self.screen_height / 2)


func _process(delta: float):
	follow_ball(delta)


func follow_ball(delta: float):
	const eps := 10.0
	var ball_position = %Ball.position
	if ball_position.x < self.tracking_pos * self.screen_width:
		return
		
	if %Ball.position.y > self.position.y + eps and \
			self.position.y < self.screen_height - self.paddle_size / 2:
		self.position.y += SPEED * delta
	elif %Ball.position.y < self.position.y - eps and \
			self.position.y > self.paddle_size / 2:
		self.position.y -= SPEED * delta
