######################
### SPACE SHOOTER  ###
######################

extends Area2D


@export var initial_speed := 2
var height_offset: float
var target: Vector2 
var rotation_velocity: float = 1
var max_rot_vel: float = 2
var Player := CharacterBody2D


func _ready():
	var offset := 50
	self.position.x = randi_range(offset, Manager.screen_width - offset)
	self.target = Vector2(
		self.position.x,
		randf_range(offset, Manager.screen_height - offset)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.rotation += delta * self.rotation_velocity
	
	if self.position.y >= target.y - 0.05:
		return
	
	self.position = self.position.lerp(target, delta * initial_speed)
	self.rotation_velocity = lerpf(
		self.rotation_velocity, max_rot_vel, self.position.y / target.y
	)


func _on_body_entered(body):
	if body.name == "Player":
		body.take_damage(1)
