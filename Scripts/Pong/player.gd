######################
###      PONG      ###
######################
extends CharacterBody2D

@export var SPEED = 300.0
const paddle_size = 64
var outline_color := Color(0.2, 1.0, 0.3, 1.0)
@onready var Character = %Character
@onready var PongManager := %PongManager
@onready var audio_stream := get_node("AudioStreamPlayer2D") as AudioStreamPlayer2D


func _ready():
	var paddle: Sprite2D = get_node("Paddle")
	Character.set_outline(paddle, outline_color)
	self.position = Vector2(0.1 * Manager.screen_width, Manager.screen_height / 2)


func _physics_process(delta):
	if PongManager.has_game_finished:
		return 
	
	var direction = Input.get_axis("ui_up", "ui_down")
	if direction:
		self.velocity.y = direction * SPEED
	else:
		self.velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	self.position.y = Character.clamp_y(self.position.y, self.paddle_size)


func reset():
	self.position = Character.reset(self.position)


func play_hit_audio():
	audio_stream.play()
