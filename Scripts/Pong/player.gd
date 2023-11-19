######################
###      PONG      ###
######################
extends CharacterBody2D

@export var SPEED = 300.0
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height") 
const paddle_size = 48

func _ready():
	self.position = Vector2(0.1 * self.screen_width, self.screen_height / 2)


func _physics_process(delta):
	var direction = Input.get_axis("ui_up", "ui_down")
	if direction:
		self.velocity.y = direction * SPEED
	else:
		self.velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	
	self.position.y = min(self.position.y, self.screen_height - self.paddle_size / 2)
	self.position.y = max(self.position.y, self.paddle_size / 2)
